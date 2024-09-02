# Generated by Django 4.2.11 on 2024-05-26 21:37

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('wagtailmedia', '0004_duration_optional_floatfield'),
        ('js_blog_app', '0006_blogindexpage_nombre_campana'),
    ]

    operations = [
        migrations.AddField(
            model_name='blogindexpage',
            name='video',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='wagtailmedia.media'),
        ),
    ]