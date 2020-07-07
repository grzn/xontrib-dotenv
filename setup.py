from setuptools import setup
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

setup(
    name='xontrib-dotenv',
    version='1.0',
    description='Dotenv for Xonsh shell',
    long_description='TBD',
    url='https://github.com/grzn/xontrib-dotenv',
    author='Guy Rozendorn',
    author_email='guy@rzn.co.il',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
    ],
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
)
