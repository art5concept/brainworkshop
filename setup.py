from setuptools import setup

setup(
    name='brainworkshop',
    version='4.8.4',
    description='Dual N-Back mental exercise',
    author='Paul Hoskinson',
    author_email='plhosk@gmail.com',
    url='http://brainworkshop.net/',
    scripts=['brainworkshop.pyw'],
    data_files=[
        ('share/brainworkshop/res', ['res']),
        ('share/brainworkshop/data', ['data']),
    ],
    install_requires=[
        'pyglet>=1.4.10',
    ],
    classifiers=[
        'Programming Language :: Python :: 2',
        'Topic :: Games/Entertainment :: Puzzle',
    ],
)
