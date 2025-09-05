from django.contrib import admin
from .models import *
# Register your models here.

@admin.register(JobAdvert)
class JobAdvertAdmin(admin.ModelAdmin):
    list_display = ['title', 'company_name', 'employment_type', 'experience_level', 'is_published', 'deadline', 'created_by']
    list_filter = ['employment_type', 'experience_level', 'is_published', 'deadline']

@admin.register(JobApplication)
class JobApplicationAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'job_advert', 'status']





