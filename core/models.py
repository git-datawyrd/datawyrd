from django.db import models

# Create your models here.

class Categoria(models.Model):
    cod_categoria = models.CharField(max_length=100, unique=True)
    categoria = models.CharField(max_length=100)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'categoria'
        verbose_name_plural = 'categorias'
        ordering = ['categoria']  # Ordena alfabéticamente por nombre

    def __str__(self):
        return self.categoria

class Moneda(models.Model):
    cod_moneda = models.CharField(max_length=5, unique=True)  # ejemplo: USD, EUR
    moneda = models.CharField(max_length=50)  # ejemplo: Dólar estadounidense
    activo = models.BooleanField(default=True)  # por defecto True, si es la principal
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'moneda'
        verbose_name_plural = 'monedas'
        ordering = ['moneda']

    def __str__(self):
        return f"{self.moneda} ({self.cod_moneda})"

class Pais(models.Model):
    cod_pais = models.CharField(max_length=3, unique=True)  # ISO 3166-1 alpha-3, por ejemplo: 'ARG'
    pais = models.CharField(max_length=100)
    moneda = models.ForeignKey(Moneda, on_delete=models.PROTECT)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'país'
        verbose_name_plural = 'países'

    def __str__(self):
        return self.pais

class Ciudad(models.Model):
    cod_ciudad = models.CharField(max_length=5)
    ciudad = models.CharField(max_length=100)
    pais = models.ForeignKey(Pais, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'ciudad'
        verbose_name_plural = 'ciudades'

    def __str__(self):
        return self.ciudad