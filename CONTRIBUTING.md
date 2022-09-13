# Contributing to the Observability Workshop

When working on the workshop, we advise that you review your changes locally before committing them.

Use ```mkdocs serve``` live preview your changes (as you type) on your local machine.

Use ```deploy.sh``` to deploy when you have completed your changes.

## To setup the first time
```
cd otelworkshop
python3 -m venv venv
source venv/bin/activate
pip3 install -r docs/doc-tools/requirements.txt
```

## Each new session setup
```
cd otelworkshop
source venv/bin/activate
```

## To debug
```
mkdocs serve
```

## To deploy
```
./deploy.sh
```
