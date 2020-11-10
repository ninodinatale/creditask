def test_get_todo_tasks_by_user_email(self):
    group = create_group()
    user_1 = create_user(group=group)
    user_2 = create_user(group=group)

    now = datetime.datetime.utcnow()

    # all good
    task_1 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now
    )

    # all good
    task_2 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=-1)
    )

    # wrong state
    task_3 = create_task(
        group=group,
        user=user_1,
        state=TaskState.APPROVED
    )

    # wrong user
    task_4 = create_task(
        group=group,
        user=user_2,
        state=TaskState.TO_DO
    )

    # wrong state
    task_5 = create_task(
        group=group,
        user=user_1,
        state=TaskState.APPROVED
    )

    # all good
    task_6 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=1)
    )

    # wrong user
    task_7 = create_task(
        group=group,
        user=user_2,
        state=TaskState.TO_DO
    )

    # all good
    task_8 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=-2)
    )

    # wrong user
    task_9 = create_task(
        group=group,
        user=user_2,
        state=TaskState.TO_DO
    )

    # all good
    task_10 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=2)
    )

    # all good
    task_11 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=3)
    )

    # all good
    task_12 = create_task(
        group=group,
        user=user_1,
        state=TaskState.TO_DO,
        period_end=now + datetime.timedelta(days=-5)
    )

    tasks = get_todo_tasks_by_user_email(user_1.email)

    self.assertEquals(7, len(tasks))

    # checking sort order
    self.assertEquals(task_12, tasks[0])
    self.assertEquals(task_8, tasks[1])
    self.assertEquals(task_2, tasks[2])
    self.assertEquals(task_1, tasks[3])
    self.assertEquals(task_6, tasks[4])
    self.assertEquals(task_10, tasks[5])
    self.assertEquals(task_11, tasks[6])


    def test_get_done_tasks_to_approve_by_user_email(self):
        group = create_group()
        user_1 = create_user(group=group)
        user_2 = create_user(group=group)

        now = datetime.datetime.utcnow()

        # all good
        task_1 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now
        )

        # all good
        task_2 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong state
        task_3 = create_task(
            group=group,
            user=user_1,
            state=TaskState.APPROVED
        )

        # wrong user
        task_4 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # wrong state
        task_5 = create_task(
            group=group,
            user=user_1,
            state=TaskState.APPROVED
        )

        # all good
        task_6 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong user
        task_7 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # all good
        task_8 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=-2)
        )

        # wrong user
        task_9 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # all good
        task_10 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=2)
        )

        # all good
        task_11 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=3)
        )

        # all good
        task_12 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=-5)
        )

        tasks = get_done_tasks_to_approve_by_user_email(user_1.email)

        self.assertEquals(7, len(tasks))

        # checking sort order
        self.assertEquals(task_12, tasks[0])
        self.assertEquals(task_8, tasks[1])
        self.assertEquals(task_2, tasks[2])
        self.assertEquals(task_1, tasks[3])
        self.assertEquals(task_6, tasks[4])
        self.assertEquals(task_10, tasks[5])
        self.assertEquals(task_11, tasks[6])

    def test_get_unassigned_tasks(self):
        group_1 = create_group()
        group_2 = create_group()
        group_3 = create_group()
        user_1 = create_user(group=group_1)
        user_2 = create_user(group=group_1)
        user_3 = create_user(group=group_1)

        now = datetime.datetime.utcnow()

        # wrong user
        task_1 = create_task(
            group=group_1,
            user=user_2,
            period_end=now
        )

        # ok
        task_2 = create_task(
            group=group_1,
            user=None,
            period_end=now
        )

        # wrong group
        task_3 = create_task(
            group=group_2,
            user=None,
            period_end=now
        )

        # ok
        task_4 = create_task(
            group=group_1,
            user=None,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong user and wrong group
        task_5 = create_task(
            group=group_2,
            user=user_3,
            period_end=now
        )

        # ok
        task_6 = create_task(
            group=group_1,
            user=None,
            period_end=now + datetime.timedelta(days=-2)
        )

        # ok
        task_7 = create_task(
            group=group_1,
            user=None,
            period_end=now + datetime.timedelta(days=2)
        )

        # ok
        task_8 = create_task(
            group=group_1,
            user=None,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong group
        task_9 = create_task(
            group=group_3,
            user=None,
            period_end=now + datetime.timedelta(days=1)
        )

        tasks = get_unassigned_tasks(group_1.id)

        self.assertEquals(5, len(tasks))

        # checking sort order
        self.assertEquals(task_6, tasks[0])
        self.assertEquals(task_4, tasks[1])
        self.assertEquals(task_2, tasks[2])
        self.assertEquals(task_8, tasks[3])
        self.assertEquals(task_7, tasks[4])

    @mock.patch('creditask.services.task_service.merge_values')
    @mock.patch(
        'creditask.services.task_service.validate_new_properties_based_on_task_state')
    @mock.patch('creditask.services.task_service.validate_state_change')
    @mock.patch('creditask.services.task_service.Task')
    def test_save_task(self, mock_task,
                       mock_validate_state_change,
                       mock_validate_new_properties_based_on_task_state,
                       mock_merge_values):
        group = create_group()
        user_1 = create_user(group=group)
        user_2 = create_user(group=group)
        user_3 = create_user(group=group)
        task = create_task(group=group)
        with self.assertRaises(ValidationError,
                               msg='should raise validation error if '
                                   'current_user is None'):
            save_task(None)

        with self.subTest('should make an update if id is passed'):
            calling_kwargs = dict(id=task.id)
            return_value = save_task(user_1, **calling_kwargs)
            self.assertEquals(calling_kwargs,
                              mock_validate_task_properties.call_args.kwargs,
                              'first argument of validate_task_properties '
                              'needs to be to kwargs')
            self.assertEquals((task,),
                              mock_validate_state_change.call_args.args,
                              'first argument of validate_state_change '
                              'needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_validate_state_change.call_args.kwargs,
                              'second argument of validate_state_change '
                              'needs to be to kwargs')
            self.assertEquals((task,),
                              mock_validate_new_properties_based_on_task_state.call_args.args,
                              'first argument of '
                              'mock_validate_new_properties_based_on_task_state'
                              ' needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_validate_new_properties_based_on_task_state.call_args.kwargs,
                              'second argument of '
                              'mock_validate_new_properties_based_on_task_state'
                              ' needs to be to kwargs')
            self.assertEquals((task, user_1), mock_merge_values.call_args.args,
                              'first argument of merge_values '
                              'needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_merge_values.call_args.kwargs,
                              'third argument of merge_values '
                              'needs to be to kwargs')
            self.assertEquals(task, return_value, 'should return updated task')

        with self.subTest('should make an insert if no id is passed'):
            calling_kwargs = dict()
            return_value = save_task(user_1, **calling_kwargs)
            self.assertNotEquals(task, return_value,
                                 'should return created task')

        with self.subTest('should set created_by and group if provided'):
            group_2 = create_group()
            return_value = save_task(user_1, created_by=user_3, group=group_2)

            self.assertEquals(user_3, return_value.created_by)
            self.assertEquals(group_2, return_value.group)

        with self.assertRaises(ValidationError,
                               msg='should raise Validation error if different '
                                   'created_by.id and created_by_id provided'):
            save_task(user_1, created_by=user_3,
                      created_by_id=user_1.id)

        with self.subTest('should set created_by and group if not provided'):
            calling_kwargs = dict()
            return_value = save_task(user_1, **calling_kwargs)

            self.assertEquals(user_1, return_value.created_by)
            self.assertEquals(group, return_value.group)

        with self.assertRaises(ValidationError,
                               msg='should raise Validation error if different '
                                   'group.id and group_id provided'):
            group_2 = create_group()
            save_task(user_1, group=group,
                      group_id=group_2.id)

        with self.subTest('should create approvals for users in group'):
            created_approvals = list(return_value.approvals.all())
            users_in_approvals = map(lambda a: a.user, created_approvals)
            self.assertEquals(3, len(created_approvals))
            self.assertIn(user_1, users_in_approvals)
            self.assertIn(user_2, users_in_approvals)
            self.assertIn(user_3, users_in_approvals)
            with self.subTest('created approvals should have correct property '
                              'values'):
                for a in created_approvals:
                    self.assertEquals(ApprovalState.NONE, a.state)
                    self.assertEquals(return_value, a.task)
                    self.assertEquals(user_1, a.created_by)
