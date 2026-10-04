# PageLoom support site

Static pages for App Store Connect.

- Support: `index.html`
- Privacy: `privacy.html`

## Publish on GitHub Pages

From this `site` folder, in Terminal:

```bash
cd site
git init
git add .
git commit -m "Add PageLoom support and privacy pages."
gh auth login
gh repo create pageloom-support --public --source=. --remote=origin --push
gh api -X POST "repos/$(gh api user --jq .login)/pageloom-support/pages" -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/"
```

After a minute the URLs are:

- Support: `https://<your-github-username>.github.io/pageloom-support/`
- Privacy: `https://<your-github-username>.github.io/pageloom-support/privacy.html`

Paste those into App Store Connect as Support URL and Privacy Policy URL.

## Local preview

```bash
python3 -m http.server 8080 --directory site
```

Then open http://127.0.0.1:8080
