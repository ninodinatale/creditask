# Generated by Django 3.1.4 on 2020-12-20 15:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('creditask', '0003_auto_20201217_2245'),
    ]

    operations = [
        migrations.AddField(
            model_name='approval',
            name='message',
            field=models.TextField(default='', max_length=240),
        ),
    ]
