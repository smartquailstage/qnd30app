from django.db import models
from wagtail.core.models import Page
from wagtail.core.fields import RichTextField
from wagtail.images.edit_handlers import ImageChooserPanel
from wagtail.admin.edit_handlers import FieldPanel, StreamFieldPanel
from wagtail.core.fields import StreamField
from wagtail.core import blocks
from wagtail.embeds.blocks import EmbedBlock
from taggit.models import TaggedItemBase
from taggit.managers import TaggableManager


class BlogIndexPage(Page):
    title_ini = RichTextField(blank=True, verbose_name="Titulo de inicio")
    subtitle_ini = RichTextField(blank=True, verbose_name="Frase de inicio")
    intro = RichTextField(blank=True)

    image = models.ForeignKey(
        'wagtailimages.Image',
        null=True,
        blank=True,
        on_delete=models.SET_NULL
    )

    content_panels = Page.content_panels + [
        FieldPanel('title_ini', classname="full"),
        FieldPanel('intro', classname="full"),
        FieldPanel('subtitle_ini', classname="full"),
        ImageChooserPanel('image')
    ]

    def get_context(self, request):
        # Update context to include only published posts,
        # in reverse chronological order
        context = super(BlogIndexPage, self).get_context(request)
        live_blogpages = self.get_children().live()
        context['blogpages'] = live_blogpages.order_by('-first_published_at')
        return context


class BlogPageTag(TaggedItemBase):
    content_object = models.ForeignKey('BlogPage', on_delete=models.CASCADE, related_name='tagged_items')


class BlogPage(Page):
    image = models.ForeignKey(
        'wagtailimages.Image',
        null=True,
        blank=True,
        on_delete=models.SET_NULL
    )
    date = models.DateField("Post date")
    intro = models.CharField(max_length=250)
    body = StreamField([
        ('heading', blocks.CharBlock(classname="full title", icon="title")),
        ('paragraph', blocks.RichTextBlock(icon="pilcrow")),
        ('embed', EmbedBlock(icon="media")),
    ])
    tags = TaggableManager(through=BlogPageTag, blank=True)


    content_panels = Page.content_panels + [
        FieldPanel('date'),
        FieldPanel('intro',classname="full" ),
        FieldPanel('image'),
        StreamFieldPanel('body'),
        FieldPanel('tags'),
    ]
