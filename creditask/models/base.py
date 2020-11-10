from django.db import models
from itertools import chain


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

    # TODO test
    def to_dict(self):
        """
        Creates a dict with all the fields: values of the entity.
        :return:
        """
        opts = self._meta
        data = {}
        for f in chain(opts.concrete_fields, opts.private_fields):
            data[f.name] = f.value_from_object(self)
        for f in opts.many_to_many:
            data[f.name] = [i.id for i in f.value_from_object(self)]
        return data

    class Meta:
        abstract = True
