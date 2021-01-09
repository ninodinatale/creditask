from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Grocery, User, BaseModel


def get_all_not_in_cart(group_id: int) -> List[Grocery]:
    return Grocery.objects.filter(group_id=group_id,
                                  in_cart=False)


def get_all_in_cart(group_id: int) -> List[Grocery]:
    return Grocery.objects.filter(group_id=group_id,
                                  in_cart=True)


# TODO test
def save_grocery(current_user: User, **kwargs):
    if current_user is None:
        raise ValidationError('current_user may not be None')

    if 'id' not in kwargs:
        return Grocery.objects.create(group_id=current_user.group_id,
                                      **kwargs)
    else:
        grocery = Grocery.objects.get(id=kwargs.get('id'))
        merge_values(grocery, **kwargs).save()
        return grocery


# TODO test
def delete_grocery(id: int):
    if id is None:
        raise ValidationError('id may not be None')
    Grocery(id=id).delete()



# TODO test
def merge_values(entity_to_merge_into: BaseModel, **kwargs) -> BaseModel:
    for key, value in kwargs.items():
        if key == 'id' or getattr(entity_to_merge_into, key) == value:
            # no changes
            continue
        setattr(entity_to_merge_into, key, value)

    return entity_to_merge_into
