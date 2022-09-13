from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import Product
from ..pagination import GenericPagination
from ..serializers import ProductSerializer


class ProductListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered products.
        """
        products = Product.objects.all()
        product_serializer = ProductSerializer(products, many=True)
        paginator = GenericPagination()
        page_product_list = paginator.paginate_queryset(product_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_product_list)

    def post(self, request, *args, **kwargs):
        """
        Create a product.
        """
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProductView(APIView):
    """
    Retrieve, update or delete a product instance.
    """

    def get_object(self, pk):
        try:
            return Product.objects.get(pk=pk)
        except Product.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a product by ID.
        """
        product = self.get_object(pk)
        serializer = ProductSerializer(product)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a product by ID.
        """
        product = self.get_object(pk)
        product.id = pk
        serializer = ProductSerializer(product, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a product by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
