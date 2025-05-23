# Generated by Django 5.2 on 2025-04-24 14:12

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('core', '0004_ciudad'),
    ]

    operations = [
        migrations.CreateModel(
            name='LeadContacto',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre_lead', models.CharField(max_length=100)),
                ('email_lead', models.EmailField(max_length=254)),
                ('tlf_lead', models.CharField(max_length=50)),
                ('mensaje_lead', models.TextField(blank=True)),
                ('fecha_contacto', models.DateTimeField(auto_now_add=True)),
                ('cod_categoria', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.categoria')),
            ],
        ),
    ]
