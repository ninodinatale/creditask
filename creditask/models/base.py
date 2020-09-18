from django.db import models


# TODO not entirely tested yet
class BaseModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)

    # TODO: set by jwt token
    created_by = models.ForeignKey('User', related_name='+',
                                   on_delete=models.CASCADE)
    is_deleted: bool = models.BooleanField(default=False)

    def delete(self, using=None, keep_parents=False):
        """deleting is not allowed"""
        raise TypeError('Delete is not allowed. Insert a new row with '
                        'is_deleted = True instead.')

    class Meta:
        abstract = True
