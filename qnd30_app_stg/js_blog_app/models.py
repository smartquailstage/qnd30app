from django.db import models
from wagtail.models import Page
from wagtail.fields import RichTextField
from wagtail.admin.panels import FieldPanel
from wagtail.fields import StreamField
from wagtail import blocks
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
        FieldPanel('image')
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
    ],use_json_field=True)
    tags = TaggableManager(through=BlogPageTag, blank=True)


    content_panels = Page.content_panels + [
        FieldPanel('date'),
        FieldPanel('intro',classname="full" ),
        FieldPanel('image'),
        FieldPanel('body'),
        FieldPanel('tags'),
    ]
