# Laravel Backend

## Initialize a New Laravel Application

```bash
cd backend/laravel
composer create-project laravel/laravel sample
cd sample
cp .env.example .env
php artisan key:generate
php artisan serve
```

## Environment Variables

Set these in your `.env` file or in Render's environment dashboard:

```
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=umfdb
DB_USERNAME=umfuser
DB_PASSWORD=umfpassword
APP_KEY=base64:GENERATED_BY_ARTISAN
APP_ENV=local
APP_DEBUG=true
```

## Docker Build

The Dockerfile at `backend/laravel/Dockerfile` expects a `composer.json` and `public/` directory.
After running `composer create-project`, copy the output into this folder before building.

## Deployment to Render

Render reads `render.yaml` from the repository root. The `umf-laravel` service entry points to this Dockerfile.
Set all environment variables in the Render dashboard under Environment → Environment Variables.
