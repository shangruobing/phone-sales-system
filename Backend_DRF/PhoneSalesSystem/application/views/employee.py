from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import Employee
from ..pagination import GenericPagination
from ..serializers import EmployeeSerializer


class EmployeeListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered employees.
        """
        employees = Employee.objects.all()
        employee_serializer = EmployeeSerializer(employees, many=True)
        paginator = GenericPagination()
        page_employee_list = paginator.paginate_queryset(employee_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_employee_list)

    def post(self, request, *args, **kwargs):
        """
        Create a employee.
        """
        serializer = EmployeeSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class EmployeeView(APIView):
    """
    Retrieve, update or delete a employee instance.
    """

    def get_object(self, pk):
        try:
            return Employee.objects.get(pk=pk)
        except Employee.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a employee by ID.
        """
        employee = self.get_object(pk)
        serializer = EmployeeSerializer(employee)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a employee by ID.
        """
        employee = self.get_object(pk)
        employee.id = pk
        serializer = EmployeeSerializer(employee, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a employee by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
