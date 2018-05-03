import os

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
}

PDFTK_PATH = "/usr/bin/pdftk"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'farnsworth',
        'USER': 'robroy',
        'PASSWORD': os.environ.get('DB_PASSWORD', ''),
        'HOST': 'legacy-v1.cxqfi7alboqd.us-east-1.rds.amazonaws.com',
        'PORT': 3306
    }
}

DEFAULT_FILE_STORAGE = 'farnsworth.storages.S3BotoMediaStorage'
AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID', '')
AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY', '')
AWS_MEDIA_STORAGE_BUCKET_NAME = 'turbopatent-media'

APP_CONFIG = {
    'RENDERER': 'redirect',
    'DEFAULTS': {},
    'APPS': {
        'farnsworth': {
            'URL': 'http://{host}:4205/',
            'STATIC_URL': '/'
        },
        'terry': {
            'URL': 'http://{host}:4705/',
            'STATIC_URL': '/'
        },
        'morgan-proctor': {
            'URL': 'http://{host}:4600/',
            'STATIC_URL': '/'
        },
        'eureka': {
            'URL': 'http://{host}:4800',
            'STATIC_URL': '/'
        },
        'zapp': {
            'URL': 'http://{host}:4900',
            'STATIC_URL': '/'
        },
        'awesome-express': {
            'URL': 'http://{host}:5000',
            'STATIC_URL': '/'
        },
        'calculon': {
            'URL': 'http://{host}:5100',
            'STATIC_URL': '/'
        },
        'groening': {
            'URL': 'http://{host}:5200',
            'STATIC_URL': '/'
        },
        'keeler': {
            'URL': 'http://{host}:5300',
            'STATIC_URL': '/'
        }
    }
}
