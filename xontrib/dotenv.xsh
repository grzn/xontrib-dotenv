import os
import glob
import contextlib


class DotEnv(object):
    def __init__(self):
        self.stack = contextlib.ExitStack()
        self.on_top_dirs = []
        self.directories = []

    def push(self, dirpath='.'):
        return self.stack.enter_context(dotenv_dir_context(dirpath))

    def add_on_top(self, dirpath='.'):
        dirpath = os.path.abspath(dirpath)
        self.on_top_dirs.append(dirpath)
        self.push(dirpath)

    def pop_from_top(self):
        self.on_top_dirs.pop()
        self.close_all()
        self.push('.')
        self.apply_on_top()

    def apply_on_top(self):
        for dirpath in self.on_top_dirs:
            self.push(dirpath)

    def close_all(self):
        self.stack.pop_all().close()

    def on_chdir_callback(self):
        def callback(olddir, newdir, **kwargs):
            if newdir in self.directories:
                return
            if not all(newdir.startswith(dirpath) for dirpath in self.directories):
                self.directories = []
            self.close_all()
            for dirpath in self.directories:
                self.push(dirpath)
            if self.push(newdir):
                self.directories.append(newdir)
            self.apply_on_top()
        return callback

    def reset(self):
        self.close_all()
        self.on_top_dirs = []
        self.directories = []

@contextlib.contextmanager
def dotenv_dir_context(dirpath='.'):
    with contextlib.ExitStack() as stack:
        dot_env_files = glob.glob(os.path.join(dirpath, '*.env'))
        for filepath in dot_env_files:
            stack.enter_context(dotenv_file_context(filepath))
        yield bool(dot_env_files)


@contextlib.contextmanager
def dotenv_file_context(filepath):
    environment_variables = dict()
    with open(filepath) as fd:
        for line in fd.readlines():
            key, value = line.strip().split('=',1)
            environment_variables[key] = value
    with ${...}.swap(**environment_variables):
        yield

dotenv = DotEnv()
_ = events.on_chdir(dotenv.on_chdir_callback())

aliases['dotenv'] = dotenv
