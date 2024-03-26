    
  # Project Title
  MDFramework SDK V0.0.2
  ## Description
    This is a software development kit for the MDFramework. It is a collection of tools and libraries that can be used to develop applications for the MDFramework.
  ## Usage 
# in Main.dart add this code
<?code-excerpt "readme_excerpts.dart (Example)"?>
   ```dart
     MDInit.initialize(
      apiToken: YourApiToken,
      dataToken: YourDataToken,
      encryptKey: YourEncryptKey,
      );
   ```



## Example 


```dart
      res = await MDRepo().executeProcedure(
          procedureName: ApiConstants.loginProcedure,
          dataToken: ApiConstants.dataToken,
          columnValues: [emailController.text, passwordController.text]);
  ```
 