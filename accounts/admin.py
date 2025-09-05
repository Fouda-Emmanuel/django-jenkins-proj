from django.contrib import admin
from .models import User, Token
# Register your models here.

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['email']


@admin.register(Token)
class TokenAdmin(admin.ModelAdmin):
    list_display = ['user', 'token', 'token_type', 'created_at']


