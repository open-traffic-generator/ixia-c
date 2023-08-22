# MkDocs How To

This repo contains the content for the [Ixia-c.dev](https://ixia-c.dev/) web-site.  It is built using the [Material](https://squidfunk.github.io/mkdocs-material/getting-started/) theme for [MkDocs](https://www.mkdocs.org/).

## Prerequisites

* Python 3.7+. In the commands below we assume use have `python3` executable. If you have a different name, change accordingly.

* PIP

    ```Shell
    curl -sL https://bootstrap.pypa.io/get-pip.py | python3 -
    ```

* Virtualenv (recommended)

    ```Shell
    pip install virtualenv
    ```

## How to install

1. Clone this repository and create Python virtual environment

    ```Shell
    https://github.com/open-traffic-generator/ixia-c.git --recursive
    cd ixia-c
    python3 -m venv venv
    source venv/bin/activate
    ```

2. Install required modules

    ```Shell
    pip3 install -r requirements.txt
    ```

Update contents in the `docs` directory and verify locally prior to pushing to main branch of this repo on GitHub.  Site will automatically update.

## How to verify contents locally

1. Make sure that you have Material [installed](https://squidfunk.github.io/mkdocs-material/getting-started/)

    ```sh
    python3 -m pip install mkdocs-material
    ```


2. Run the following command:

    ```sh
    mkdocs serve
    ```

You can point your browser to `index.html` in the `site` directory to view it.

## Submodules

Parts of the `docs` hierarchy are coming from submodules. To update content of the submodules to the most recent one, use:

```Shell
git submodule update --remote
```