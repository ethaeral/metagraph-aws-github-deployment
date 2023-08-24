# AWS CloudFormation Template


## Declares a single resource of type AWS::S3::Bucket: with the name with default settings
```yaml 
Resources:
  ResourceName: <--->
    Type: 'AWS::S3::Bucket'
```
## Adding different properties from default
```yaml 
Resources:
  ResourceName:
    Type: 'AWS::S3::Bucket'
    Properties:
      AccessControl: PublicRead <--->
```
## Example with subproperties
```yaml 
Resources:
  ResourceName:
    Type: 'AWS::S3::Bucket'
    Properties:
      AccessControl: PublicRead
      WebsiteConfiguration:
        IndexDocument: index.html <--->
        ErrorDocument: error.html <--->
```
## Use ref functions to set resource as a property
```yaml
Resources:
  Ec2Instance:
    Type: 'AWS::EC2::Instance'
    Properties:
      SecurityGroups:
        - !Ref InstanceSecurityGroup <--->
      KeyName: mykey
      ImageId: ''
  InstanceSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Enable SSH access via port 22
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
```
## Security Group example
```yaml
Resources:
  Ec2Instance:
    Type: 'AWS::EC2::Instance'
    Properties:
      SecurityGroups:
        - !Ref InstanceSecurityGroup
        - MyExistingSecurityGroup
      KeyName: mykey
      ImageId: ami-7a11e213
  InstanceSecurityGroup: <--->
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Enable SSH access via port 22
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
```
## Key pairs
```yaml
Parameters:
  KeyName: <--->
    Description: The EC2 Key Pair to allow SSH access to the instance
    Type: 'AWS::EC2::KeyPair::KeyName'
Resources:
  Ec2Instance:
    Type: 'AWS::EC2::Instance'
    Properties:
      SecurityGroups:
        - !Ref InstanceSecurityGroup
        - MyExistingSecurityGroup
      KeyName: !Ref KeyName
      ImageId: ami-7a11e213
  InstanceSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Enable SSH access via port 22
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
```
## The Fn::GetAtt function takes two parameters, the logical name of the resource and the name of the attribute to be retrieved. 
```yaml
Resources:
  myBucket:
    Type: 'AWS::S3::Bucket'
  myDistribution:
    Type: 'AWS::CloudFront::Distribution' <--->
    Properties:
      DistributionConfig:
        Origins:
          - DomainName: !GetAtt 
              - myBucket
              - DomainName
            Id: myS3Origin
            S3OriginConfig: {}
        Enabled: 'true'
        DefaultCacheBehavior:
          TargetOriginId: myS3Origin
          ForwardedValues:
            QueryString: 'false'
          ViewerProtocolPolicy: allow-all
```
## Receiving user input using input parameters
You'll notice that the KeyName parameter has no Default attribute and the other parameters do. For example, the WordPressUser parameter has the attribute Default: admin, but the KeyName parameter has none. Users must specify a key name value at stack creation. If they don’t, CloudFormation fails to create the stack and throws an exception: Parameters: [KeyName] must have values.
```yaml
Parameters:
  KeyName: <--->
    Description: Name of an existing EC2 KeyPair to enable SSH access into the WordPress web server
    Type: AWS::EC2::KeyPair::KeyName
  WordPressUser:
    Default: admin <--->
    NoEcho: true
    Description: The WordPress database admin account user name
    Type: String
    MinLength: 1
    MaxLength: 16
    AllowedPattern: "[a-zA-Z][a-zA-Z0-9]*"
  WebServerPort:
    Default: 8888
    Description: TCP/IP port for the WordPress web server
    Type: Number
    MinValue: 1
    MaxValue: 65535
```
## Specifying conditional values using mappings
To use a map to return a value, you use the [Fn::FindInMap](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-findinmap.html) function,
```yaml
Parameters:
  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance
    Type: String
Mappings: <--->
  RegionMap: 
    us-east-1:
      AMI: ami-76f0061f
    us-west-1:
      AMI: ami-655a0a20
    eu-west-1:
      AMI: ami-7fd4e10b
    ap-southeast-1:
      AMI: ami-72621c20
    ap-northeast-1:
      AMI: ami-8e08a38f
Resources:
  Ec2Instance:
    Type: 'AWS::EC2::Instance'
    Properties:
      KeyName: !Ref KeyName
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - AMI
      UserData: !Base64 '80'
```
## Constructed values and output values
 the Fn::Join function specifies an empty string as the delimiter and HTTP:, the value of the WebServerPort parameter, and a / character as the values to concatenate. If WebServerPort had a value of 8888, the Target property would be set to the following value:
```yaml
Resources:
  ElasticLoadBalancer:
    Type: 'AWS::ElasticLoadBalancing::LoadBalancer'
    Properties:
      AvailabilityZones: !GetAZs ''
      Instances:
        - !Ref Ec2Instance1
        - !Ref Ec2Instance2
      Listeners:
        - LoadBalancerPort: '80'
          InstancePort: !Ref WebServerPort
          Protocol: HTTP
      HealthCheck:
        Target: !Join <- HTTP:8888/ ->
          - ''
          - - 'HTTP:'
            - !Ref WebServerPort
            - /
        HealthyThreshold: '3'
        UnhealthyThreshold: '5'
        Interval: '30'
        Timeout: '5'
```
```yaml
Outputs:
  InstallURL:
    Value: !Join 
      - ''
      - - 'http://'
        - !GetAtt 
          - ElasticLoadBalancer
          - DNSName
        - /wp-admin/install.php
    Description: Installation URL of the WordPress website
  WebsiteURL:
    Value: !Join <- http://mywptests-elasticl-1gb51l6sl8y5v-206169572.us-east-2.elb.amazonaws.com/wp-admin/install.php ->
      - ''
      - - 'http://'
        - !GetAtt 
          - ElasticLoadBalancer
          - DNSName
```