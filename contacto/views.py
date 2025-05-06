from django.shortcuts import render
from django.contrib import messages
from .forms import FormularioLead
from .models import LeadContacto

def contacto_view(request):
    form = FormularioLead()  # Inicializamos el formulario vacío

    if request.method == 'POST':
        form = FormularioLead(request.POST)  # Recibimos los datos del formulario
        if form.is_valid():
            # Guardamos la información en la base de datos
            categoria_obj = form.cleaned_data['cod_categoria']
            LeadContacto.objects.create(
                cod_categoria=categoria_obj,
                nombre_lead=form.cleaned_data['nombre_lead'],
                email_lead=form.cleaned_data['email_lead'],
                tlf_lead=form.cleaned_data['tlf_lead'],
                mensaje_lead=form.cleaned_data['mensaje_lead'],
            )

            # Enviamos el mensaje de éxito
            messages.success(request, "Gracias por tu mensaje. Nos pondremos en contacto pronto.")

            # Limpiamos el formulario después de enviarlo correctamente
            form = FormularioLead()  # Reiniciamos el formulario

    return render(request, 'contacto/contacto.html', {'form': form})
