package ZohoImport; 

use strict; 
use Exporter; 
our $VERSION = 0.10;
our @EXPORT_OK = qw( get_data new ImportNewData);
use XML::Simple;
use LWP::UserAgent;

#use Data::Dumper;

my $g_data_hash;
my @g_data_array;

# our $currentData;
    	 my @dbColumns =          qw(  
                    Lead_BusinessName 
                    Lead_FirstName 
                    Lead_LastName 
                    Lead_BusinessPhone 
                    Lead_MobilePhone 
                    Lead_Email 
                    Lead_Dealer_ReferedTo 
                    Lead_ReferalDate 
                    Lead_Street  
                    Lead_City  
                    Lead_State  
                    Lead_Zip  
                    Lead_Equipment_Type  
                    Lead_Model   
                    Lead_Notes  
                    Lead_Origin
                    Refered_By_Data 
                    Finance_Required 
                    Sales_Status 
                    Sales_Quote 
                    Sales_Quote_Other 
                     Lead_Sales_Create_Date
                     Lead_Error_Type );

sub ImportNewData
{
    use YAML qw(LoadFile);

    my $current_grid_index = shift;
   
    print "ImportNewData -- begin\n";

    my $settings = LoadFile('.\res\zohoIn.yaml');
    
    
my $emailAddr = ${$settings}[0];
my $dbName = ${$settings}[1];
my $tableName = ${$settings}[2];
my $authtoken = ${$settings}[3];
my $action = ${$settings}[4];
my $format = ${$settings}[5];
my $version = ${$settings}[6];


# Create a user agent
my $ua = LWP::UserAgent->new();
 
# URL for service (endpoint)
my $url =  'https://reportsapi.zoho.com/api/' . $emailAddr . '/' . $dbName . '/' . $tableName . '/';

# Populate POST data fields (key => value pairs)
my (%post_data) = (
                  'ZOHO_ACTION' => $action,
                  'ZOHO_OUTPUT_FORMAT' => $format,
                  'ZOHO_ERROR_FORMAT' => $format,
                   'authtoken' => $authtoken,
                   'ZOHO_API_VERSION' => $version
		   );
 
# Perform the request
my $response = $ua->post($url, \%post_data);
 
# Check for HTTP error codes
die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success); 
 
# Output the entry
print $response->content();


print "\n xml to hash: \n\n ";

# create object
my $xml = new XML::Simple;

# read XML file
my $data = $xml->XMLin($response->content);
my @array = @{$data->{result}->{rows}->{row}};
print " size: $#array\n";
my $size = $#array + 1;

my $i = 0;
#my %local_hash;
my @local_array;
my @data_array;

  while ($i < $size)
  {
      my %local_hash;
#	print " col - $i : $array[$i]->{column}->{Column3}->{content}\n";
    $data_array[0] = $local_hash{LeadID} = $array[$i]->{column}->{LeadID}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[1] = $local_hash{Lead_BusinessName} = $array[$i]->{column}->{Lead_BusinessName}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[2] = $local_hash{Lead_FirstName} = $array[$i]->{column}->{Lead_FirstName}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[3] = $local_hash{Lead_LastName} = $array[$i]->{column}->{Lead_LastName}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[4] = $local_hash{Lead_BusinessPhone} = $array[$i]->{column}->{Lead_BusinessPhone}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[5] = $local_hash{Lead_MobilePhone} = $array[$i]->{column}->{Lead_MobilePhone}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[6] = $local_hash{Lead_Email} = $array[$i]->{column}->{Lead_Email}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[7] = $local_hash{Lead_Dealer_ReferedTo} = $array[$i]->{column}->{Lead_Dealer_ReferedTo}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[8] = $local_hash{Lead_ReferalDate} = $array[$i]->{column}->{Lead_ReferalDate}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[9] = $local_hash{Lead_Street} = $array[$i]->{column}->{Lead_Street}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[10] = $local_hash{Lead_City} = $array[$i]->{column}->{Lead_City}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[11] = $local_hash{Lead_State} = $array[$i]->{column}->{Lead_State}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[12] = $local_hash{Lead_Zip} = $array[$i]->{column}->{Lead_Zip}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[13] = $local_hash{Lead_Equipment_Type} = $array[$i]->{column}->{Lead_Equipment_Type}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[14] = $local_hash{Lead_Model} = ".";
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[15] = $local_hash{Lead_Notes} = $array[$i]->{column}->{Lead_Notes}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[16] = $local_hash{Lead_Origin} = $array[$i]->{column}->{Lead_Origin}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[17] = $local_hash{Refered_By_Data} = $array[$i]->{column}->{Refered_By_Data}->{content};
#    print " $i: -> $local_hash{Col1} --- ";
    $data_array[18] = $local_hash{Finance_Required} = $array[$i]->{column}->{Finance_Required}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[19] = $local_hash{Sales_Status} = $array[$i]->{column}->{Sales_Status}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[20] = $local_hash{Sales_Quote} = $array[$i]->{column}->{Sales_Quote}->{content};
#    print " $i: -> $local_hash{Col2} --- ";
    $data_array[21] = $local_hash{Sales_Quote_Other} = $array[$i]->{column}->{Sales_Quote_Other}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";
    $data_array[22] = $local_hash{Lead_Sales_Create_Date} = $array[$i]->{column}->{Lead_Sales_Create_Date}->{content};
#    print " $i: -> $local_hash{Col3} --- \n";

 create_db_rec(@data_array);
#create_test(@data_array);
$local_array[$i] = \%local_hash;
        $i++;
  }

 
  @g_data_array = @local_array; 
  
#  get_data($current_grid_index);
#  create_db_rec();
  delete_all_imported();

print "ImportNewData -- end\n";

return 1;
}

=begin crud

sub get_data
{
    
#  adds new imported data to the data already in the database    
    my $grid_index = shift;
    my $self = shift;
    my $ref = shift;
    my $local_hash;
#    $ref->{grid_1}->SetCellValue($cnt_row, 0, $result[2] );
    $ref->{grid_1}->SetCellValue(0, 0, 'dummy' );
    my $size = $#g_data_array + 1 + $grid_index +1; 
    print " get data : global array size: $size\n";
    
     my $i = $grid_index + 1;
     
  while ($i < $size)
  {
            $local_hash = $g_data_array[$i];
            $ref->{grid_2}->SetCellValue($i, 0, $g_data_array[$i]->{Lead_FirstName} );
            $ref->{grid_2}->SetCellValue($i, 1, $g_data_array[$i]->{Lead_LastName} );
            $ref->{grid_2}->SetCellValue($i, 2, $g_data_array[$i]->{Lead_BusinessPhone} );
            $ref->{grid_2}->SetCellValue($i, 0, $g_data_array[$i]->{Lead_City} );
            $ref->{grid_2}->SetCellValue($i, 1, $g_data_array[$i]->{Lead_State} );
            $ref->{grid_2}->SetCellValue($i, 2, $g_data_array[$i]->{Lead_ReferalDate} );

        $i++;
  }

}

sub create_test
{
    my @dataArray = @_;
    
          my $size = $#dataArray + 1; 
    print " create test : array size: $size\n";
    
     my $i = 0;
     
  while ($i < $size)
  {
         print " index: $i ---> val: $dataArray[$i] *******";
        $i++;
  }
    print "\n end \n";
    
}

=end crud
=cut

sub create_db_rec
{
     my @dataArray = @_;
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
     
     my $lastID;
     my $et = "Imp";
     
     my $sth = $dbh->prepare("select LeadID from LeadData order by LeadID desc limit 1");
    
    $sth->execute();
     
     while (
        my @result = $sth->fetchrow_array()) {
        print "id: $result[0]\n";
        $lastID = $result[0];
     }
    
    $sth->finish;
    $lastID++;
     
     
     
	 my $tempez = join(", ",@dbColumns);

     my  $statement = "INSERT INTO LeadData (LeadID, " . $tempez . ") VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
         print "sql-insert: $statement\n";        

     $dbh->do($statement, undef, $lastID, $dataArray[1],$dataArray[2],$dataArray[3],$dataArray[4], $dataArray[5], $dataArray[6],$dataArray[7],$dataArray[8],$dataArray[9],$dataArray[10],$dataArray[11],$dataArray[12],$dataArray[13],$dataArray[14],$dataArray[15],$dataArray[16],$dataArray[17],$dataArray[18],$dataArray[19],$dataArray[20],$dataArray[21],$dataArray[22],$et);


    $dbh->disconnect;
  
}

sub delete_all_imported
{
    
    use YAML qw(LoadFile);    
    
    my $current_grid_index = shift;
   
    print "ImportNewData -- begin\n";

    my $settings = LoadFile('.\res\zohoIn.yaml');
    
    
my $emailAddr = ${$settings}[0];
my $dbName = ${$settings}[1];
my $tableName = ${$settings}[2];
my $authtoken = ${$settings}[3];
my $action = 'DELETE';
my $format = ${$settings}[5];
my $version = ${$settings}[6];


# Create a user agent
my $ua = LWP::UserAgent->new();
 
# URL for service (endpoint)
my $url =  'https://reportsapi.zoho.com/api/' . $emailAddr . '/' . $dbName . '/' . $tableName . '/';

# Populate POST data fields (key => value pairs)
my (%post_data) = (
                  'ZOHO_ACTION' => $action,
                  'ZOHO_OUTPUT_FORMAT' => $format,
                  'ZOHO_ERROR_FORMAT' => $format,
                   'authtoken' => $authtoken,
                   'ZOHO_API_VERSION' => $version
		   );
 
# Perform the request
my $response = $ua->post($url, \%post_data);
 
# Check for HTTP error codes
die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success); 
 
# Output the entry
print $response->content();
    
}


1;