from django.core.exceptions import ValidationError
from django.db import models, DataError


class BaseModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)

    # TODO: set by jwt token
    created_by = models.ForeignKey('User', on_delete=models.SET_NULL,
                                   related_name='+', null=True)
    is_deleted: bool = models.BooleanField(default=False)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def save(self, *args, **kwargs):
        # TODO fetch user id by JWT token
        if self.created_by is None:
            raise ValidationError('created_by needs to be set.')

        # updating results in creating a new record. Merge data here
        if self.id is not None:
            prev_record = self.__class__.objects.get(id=self.id)
            self.id = None

            has_changes = False

            # iterating fields to set missing values from previous record
            for field in self._meta.concrete_fields:
                if hasattr(self, field.column):

                    current_value = getattr(self, field.column)
                    prev_value = getattr(prev_record, field.column)

                    # created_by should be ignored on determining if changes
                    # have been made.
                    if field.column != 'created_by_id' and \
                            current_value != prev_value:
                        has_changes = True
                else:
                    # set missing value
                    setattr(self, field.column,
                            getattr(prev_record, field.column))

            if not has_changes:
                raise DataError(f'Tried to save {self.__class__.__name__} '
                                'without making any changes.')

        super().save(force_insert=True)

    def delete(self, using=None, keep_parents=False):
        """deleting is now allowed"""
        raise TypeError('Delete is not allowed. Insert a new row with '
                        'is_deleted = True instead.')

    class Meta:
        abstract = True
