from django.db import models
from itertools import chain


# TODO not entirely tested yet
class BaseModel(models.Model):
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
