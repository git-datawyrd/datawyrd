from django.db import models
from core.models import Categoria

# Create your models here.

class LeadContacto(models.Model):
    cod_categoria = models.ForeignKey(Categoria, on_delete=models.SET_NULL, null=True)
    nombre_lead = models.CharField(max_length=100)
    email_lead = models.EmailField()
    tlf_lead = models.CharField(max_length=50)
    mensaje_lead = models.TextField(blank=True)
    fecha_contacto = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.nombre_lead} - {self.cod_categoria}"
