# brain_gym_academy_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Vercel deployment and backend configuration (important)

When deploying the Flutter web build to Vercel you must ensure two things:

- Backend: configure a frontend URL in your Spring Boot app so email links point to your deployed frontend. In `application.yml` (or `application.properties`) add:

```yaml
app:
	frontend:
		url: http://localhost:3000 # change to your deployed Vercel URL when ready
```

Inject this value into your email service and use it to build reset links. Example in Java:

```java
@Value("${app.frontend.url}")
private String frontendUrl;

String resetLink = frontendUrl + "/reset-password?token=" + token;
```

- Vercel gotcha (routing): Vercel treats routes as static file paths. If a user opens `https://your-app.vercel.app/reset-password` Vercel will return 404 unless you rewrite all requests to `index.html`. Add `vercel.json` at project root with:

```json
{
	"rewrites": [
		{ "source": "/(.*)", "destination": "/index.html" }
	]
}
```

This ensures deep links (like `/reset-password`) are handled by your Flutter app.
