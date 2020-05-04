from django.contrib import admin

from creditask.models import User, Task, Approval, Group

admin.site.register(Group)
admin.site.register(User)
admin.site.register(Task)
admin.site.register(Approval)

