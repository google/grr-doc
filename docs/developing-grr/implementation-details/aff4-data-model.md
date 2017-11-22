# AFF4 Data Model


AFF4 was first published in 2008 as an extensible, modern forensic
storage format. The AFF4 data model allows the representation of
arbitrary objects and the association of these with semantic meaning.
The AFF4 data model is at the heart of GRR and is essential for
understanding how GRR store, analyzes and represents forensic artifacts.

AFF4 is an object oriented model. This means that all entities are just
different types of *AFF4 objects*. An AFF4 object is simply an entity,
addressable by a globally unique name, which has attributes attached to
it as well as behaviors.

Each AFF4 object has a unique urn by which it can be addressed. AFF4
objects also have optional attributes which are defined in the object’s
Schema. For example consider the following definition of an AFF4 object
representing a GRR Client:

``` python
class VFSGRRClient(aff4.AFF4Object):                                   
  """A Remote client."""

  class SchemaCls(aff4.AFF4Object.SchemaCls):                          
    """The schema for the client."""
    CERT = aff4.Attribute("metadata:cert", RDFX509Cert,                
                          "The PEM encoded cert of the client.")

    # Information about the host.
    HOSTNAME = aff4.Attribute("metadata:hostname", aff4.RDFString,     
                              "Hostname of the host.", "Host",
                              index=client_index)
```

  - An AFF4 object is simply a class which extends the AFF4Object base
    class.

  - Each AFF4 object contains a Schema - in this case the Schema extends
    the base AFF4Object schema - this means this object can contains the
    attributes on the base class in addition to these attributes.
    Attributes do not need to be set.

  - Attributes have both a name ("metadata:cert") as well as a type
    ("RDFX509Cert"). In this example, the VFSGRRClient object will
    contain a CERT attribute which will be an instance of the type
    RDFX509Cert.

  - An attribute can also be marked as ready for indexing. This means
    that whenever this attribute is updated, the corresponding index is
    also updated.

![View of an AFF4 VFSGRRClient with some of its
attributes.](images/aff4_attributes.jpg "fig:")

The figure above illustrates an AFF4 Object of type VFSGRRClient. It has
a URN of "aff4:/C.880661da867cfebd". The figure also lists all the
attributes attached to this object. Notice how some attributes are
listed under the heading *AFF4Object* (since they are defined at that
level) and some are listed under *VFSGRRClient* since they are defined
under the VFSGRRClient schema.

The figure also gives an *Age* for each attribute. This is the time when
the attribute was created. Since GRR deals with fluid, constantly
changing systems, each fact about the system must be tagged with the
point in time where that fact was known. For example, at a future time,
the hostname may change. In that case we will have several versions for
the HOSTNAME attribute, each correct for that point in time. We consider
the entire object to have a new version when a versioned attribute
changes.

![Example of multiple versions present at the same
time.](images/pslist.jpg "fig:")

The Figure above shows a process listing performed on this client. The
view we currently see shows the the process listing at one point in
time, but we can also see a UI offering to show us previous versions of
the same object.

AFF4 objects take care of their own serialization and unserialization
and the data store technology is abstracted. Usually AFF4 objects are
managed using the aff4
    FACTORY:

    In [8]: pslist = aff4.FACTORY.Open("aff4:/C.d74adcb3bef6a388/devices\    
       /memory/pslist", mode="r", age=aff4.ALL_TIMES)
    
    In [9]: pslist                                                           
    Out[9]: <AFF4MemoryStream@7F2664442250 = aff4:/C.d74adcb3bef6a388/devices/memory/pslist>
    
    In [10]: print pslist.read(500)                                          
     Offset(V) Offset(P)  Name                 PID    PPID   Thds   Hnds   Time
    ---------- ---------- -------------------- ------ ------ ------ ------ -------------------
    0xfffffa8001530b30 0x6f787b30 System                    4      0     97    520 2012-05-14 18:21:33
    0xfffffa80027119d0 0x6e5119d0 smss.exe                256      4      3     33 2012-05-14 18:21:34
    0xfffffa8002ce3060 0x6dee3060 csrss.exe               332    324      9    611 2012-05-14 18:22:25
    0xfffffa8002c3
    
    In [11]: s = pslist.Get(pslist.Schema.SIZE)                             
    
    In [12]: print type(s)                                                  
    <class 'grr.lib.aff4.RDFInteger'>
    
    In [13]: print s                                                        
    4938
    
    In [14]: print s.age                                                    
    2012-05-21 14:48:20
    
    In [15]: for s in pslist.GetValuesForAttribute(pslist.Schema.SIZE):     
       ....:     print s, s.age
    4938 2012-05-21 14:48:20
    4832 2012-05-21 14:20:30
    4938 2012-05-21 13:53:05

  - We have asked the aff4 factory to open the AFF4 object located at
    the unique location of
    *aff4:/C.d74adcb3bef6a388/devices/memory/pslist* for reading. The
    factory will now go to the data store, and retrieve all the
    attributes which comprise this object. We also indicate that we wish
    to examine all versions of all attributes on this object.

  - We receive back an AFF4 object of type *AFF4MemoryStream*. This is a
    stream (i.e. it contains data) which stores all its content in
    memory.

  - Since it is a stream, it also implements the stream interface (i.e.
    supports reading and seeking). Reading this stream gives back the
    results from running Volatility’s pslist against the memory of the
    client.

  - The SIZE attribute is attached to the stream and indicates how much
    data is contained in the stream. Using the Get() interface we
    retrieve the most recent one.

  - The attribute is strongly typed, and it is an instance of an
    RDFInteger.

  - The RDFInteger is able to stringify itself sensibly.

  - All attributes carry the timestamp when they were created. The last
    time the SIZE attribute was updated was when the object was written
    to last.

  - We can now retrieve all versions of this attribute - The pslist flow
    was run on this client 3 times at different dates. Each time the
    data is different.
