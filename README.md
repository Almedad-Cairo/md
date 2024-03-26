    
  # MDFramework SDK 
  ## Description
  -  This is a software development kit for the MDFramework. It is a collection of tools and libraries that can be used to develop applications for the MDFramework.
  ## Usage 
### in Main.dart add this code
<?code-excerpt "readme_excerpts.dart (Example)"?>
   ```dart
       MDInit.initialize(
        apiToken: YourApiToken,
        dataToken: YourDataToken,
      encryptKey: YourEncryptKey,
       );
```



## Example 


### 1. DoTransaction

```dart
    MDResponse res = await MDRepo().doTransaction(
tableName: tableName,
dataToken: ApiConstants.dataToken,

columnValues: [
//List of column values
"name", "email", "password"

],
action: WantedAction.insert);
  ```
- tableName: The name of the table you want to perform the transaction on.
- columnValues: A list of column values you want to insert into the table.
- action: The action you want to perform on the table. It can be insert, update, or delete.
- dataToken is optional.
- The response is returned as an MDResponse object.


### 2. Execute Procedure


```dart
      res = await MDRepo().executeProcedure(
          procedureName: ApiConstants.loginProcedure,
          dataToken: ApiConstants.dataToken,
          columnValues: [emailController.text, passwordController.text]);
  ```
- procedureName: The name of the procedure you want to execute.
- dataToken is optional.
- columnValues: A list of column values you want to pass to the procedure.
- The response is returned as an MDResponse object.

### 3. DoMultiTransaction

```dart
      MDResponse res = await MDReop().doMultiTransaction(
     tableNames: [
"table1",
"table2",
],
dataToken: ApiConstants.dataToken,
columnValues: [
["List of column values for table1" ],
["List of column values for table2"],
],
action: WantedAction.insert,
);
  ```
- tableNames: A list of table names you want to perform the transaction on.
- columnValues: A list of lists of column values you want to insert into the tables.
- action: The action you want to perform on the tables. It can be insert, update, or delete.
- dataToken is optional.
- The response is returned as an MDResponse object.

### 4. UploadFile

```dart
      MDResponse res = await MDRepo().uploadFile(
            image: file,
            fileType: fileExtension,
            wantedAction: WantedAction.insert,
          );
  ```
- image: The file you want to upload.
- fileType: The file extension of the file you want to upload.
- wantedAction: The action you want to perform on the file. It can be insert, update, or delete.
- The response is returned as an MDResponse object.
## Installation
```yaml
dependencies:
  md_framework: latest_version
```

 