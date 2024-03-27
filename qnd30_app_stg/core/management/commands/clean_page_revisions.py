# clean_page_revisions.py

from django.core.management.base import BaseCommand
from wagtail.core.models import Page, PageRevision

class Command(BaseCommand):
    help = 'Delete all page revisions'

    def handle(self, *args, **options):
        # Eliminar todas las revisiones de las páginas
        PageRevision.objects.all().delete()
        self.stdout.write(self.style.SUCCESS('All page revisions deleted successfully'))
