# Attaching images and video to a PR

Adapted from [`pr-screenshots`](https://github.com/github/awesome-copilot/blob/main/skills/pr-screenshots/SKILL.md) (github/awesome-copilot). Copied in rather than depended on, so this skill installs standalone; see [`CREDITS.md`](./CREDITS.md).

Embed before/after screenshots in the PR description so reviewers see the visual change without checking out the branch.

## When this applies

Any PR that changes something visible: layout, styling, CSS, charts, dashboards, data visualizations, UI components, forms, modals, error messages, CLI output, log formatting.

## The pair pattern

Place screenshots directly in the PR description body. Never wrap them in `<details>` collapse: reviewers skip images they have to click to see.

For UI changes the pair goes in a table:

```markdown
| Before | After |
| --- | --- |
| ![before](<url>) | ![after](<url>) |
```

When a recording shows the change better than stills, attach the video below the pair. Capture video with the same setup that takes the screenshots (see `## Prerequisites` in `SKILL.md`).

## Capture rules

1. **Capture the before state BEFORE making changes.** Reconstructing it later is slow and error-prone.
2. **Take screenshots at native 1x resolution.** Do not resize with PIL (it creates artifacts). Control display size in HTML when an image is too large:
   ```html
   <img src="url" width="600" alt="description">
   ```
3. **Before/after pairs must use the same viewport width and crop.** Otherwise the comparison is meaningless.
4. **Keep descriptions brief.** A sentence or two per image pointing out what changed is enough.
5. **Annotate when the change is subtle.** Add callouts when the difference is not immediately obvious.
6. **Do not commit images to the working branch just for PR screenshots.** Upload them out of band (below).

## Uploading images

### GitHub

There is no public API for uploading images to PR descriptions (drag-and-drop uses internal endpoints tied to browser cookies). The workaround: commit images to a `pr-assets` orphan branch and reference them with blob URLs:

```
github.com/{owner}/{repo}/blob/pr-assets/{file}?raw=true
```

It works but is clunky. Azure DevOps attachments (below) are the cleaner flow where available.

### Azure DevOps

Upload images as PR attachments via the REST API:

```powershell
$token = az account get-access-token `
    --resource "499b84ac-1321-427f-aa17-267ca6975798" `
    --query accessToken -o tsv

$base = "https://{org}.visualstudio.com/{projectId}/_apis/git/repositories/{repoId}"
$url = "$base/pullRequests/{prId}/attachments/screenshot.png?api-version=7.1-preview.1"

# Use HttpClient: Invoke-RestMethod can corrupt binary data
$client = New-Object System.Net.Http.HttpClient
$client.DefaultRequestHeaders.Authorization = `
    New-Object System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", $token)
$content = New-Object System.Net.Http.ByteArrayContent(
    , [System.IO.File]::ReadAllBytes("screenshot.png")
)
$content.Headers.ContentType = `
    [System.Net.Http.Headers.MediaTypeHeaderValue]::new("application/octet-stream")
$resp = $client.PostAsync($url, $content).Result
```

Reference in the PR description:

```markdown
![description](https://{org}.visualstudio.com/{projectId}/_apis/git/repositories/{repoId}/pullRequests/{prId}/attachments/screenshot.png)
```

Azure DevOps gotchas:

- Use `{org}.visualstudio.com`, NOT `dev.azure.com/{org}`: the markdown renderer uses `.visualstudio.com`, and the other format loads noticeably slower.
- Use `POST`, not `PUT` (`PUT` returns 405). API version must be `7.1-preview.1`.
- A filename cannot be re-uploaded: use a new name (e.g. `screenshot-v2.png`).
- Repo-relative paths do not work in PR descriptions: use full URLs.

## Limitations

- GitHub image upload needs the `pr-assets` workaround above.
- Azure DevOps attachment filenames cannot be reused: plan naming ahead.
