from django.db import models
from wagtail.models import Page,Orderable
from wagtail.fields import RichTextField
from wagtail.admin.panels import FieldPanel
from wagtail.fields import StreamField
from wagtail import blocks
from wagtail.embeds.blocks import EmbedBlock
from taggit.models import TaggedItemBase
from taggit.managers import TaggableManager
from modelcluster.fields import ParentalKey
from wagtail.admin.panels import (
    FieldPanel,
    FieldRowPanel,
    InlinePanel,
    MultiFieldPanel,
)
from wagtailmedia.blocks import AbstractMediaChooserBlock


class BlogHomePage(Page):
    title_ini = RichTextField(blank=True, verbose_name="Escribir una Bio resuminda")
    

    content_panels = Page.content_panels + [
        FieldPanel('title_ini', classname="full"),
        InlinePanel('galleria', label="Imagen de Fondo Barner"),
    ]

class GaleriadeImagenesBlogHome(Orderable):
    page = ParentalKey(BlogHomePage, on_delete=models.CASCADE, related_name='galleria')
    image = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 1')
    image_2 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 2')
    image_3 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 3')
    image_4 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 1')
    image_5 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 2')
    image_6 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 3')
    image_7 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 1')
    image_8 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 2')
    image_9 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen Slide Banner 3')


    panels = [
        FieldPanel('image'),
        FieldPanel('image_2'),
        FieldPanel('image_3'),
        FieldPanel('image_4'),
        FieldPanel('image_5'),
        FieldPanel('image_6'),
        FieldPanel('image_7'),
        FieldPanel('image_8'),
        FieldPanel('image_9'),
    ]


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


class VideoBlock(AbstractMediaChooserBlock):
    def render_basic(self, value, context=None):
        if not value:
            return ''

        return self.render(value, context)

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
        InlinePanel('galleria', label="Galeria para slider de post"),
        FieldPanel('body'),
        FieldPanel('tags'),
    ]


class GaleriadeImagenesBlog(Orderable):
    page = ParentalKey(BlogPage, on_delete=models.CASCADE, related_name='galleria')
    image = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Foto de perfil')
    image_2 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen de portada')
    image_3 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 1 de galeria')
    image_4 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 2 de galeria')
    image_5 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 3 de galeria')
    image_6 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 4 de galeria')
    image_7 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 5 de galeria')
    image_8 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 6 de galeria')
    image_9 = models.ForeignKey('wagtailimages.Image',null=True,blank=True,on_delete=models.SET_NULL,related_name='+',verbose_name='Imagen 7 de galeria')
    video =  StreamField([('video', VideoBlock()),],null=True,blank=True)
    video_2 =  StreamField([('video', VideoBlock()),],null=True,blank=True)
    video_3 =  StreamField([('video', VideoBlock()),],null=True,blank=True)


    panels = [
        FieldPanel('image'),
        FieldPanel('image_2'),
        FieldPanel('image_3'),
        FieldPanel('image_4'),
        FieldPanel('image_5'),
        FieldPanel('image_6'),
        FieldPanel('image_7'),
        FieldPanel('image_8'),
        FieldPanel('image_9'),
        FieldPanel('video'),
        FieldPanel('video_2'),
        FieldPanel('video_3'),
    ]