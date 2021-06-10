Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EF03A2609
	for <lists+kvm-ppc@lfdr.de>; Thu, 10 Jun 2021 10:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJIEG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Jun 2021 04:04:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230262AbhFJID3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 10 Jun 2021 04:03:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A7YCQt088139;
        Thu, 10 Jun 2021 04:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RhdnX/r7nV7fwvMp0D4eIzWgIqRB2ZmBIZQQUfOAIQ8=;
 b=UBTB1b5mXeWQ8JSQhx/ycner4WIRRJV3wpVPYM6ZUTiPQmovW2ppLOTyVYxtytLN2B2c
 tslokLGznZN6Dreg63thNEh3pYlz9O5WABLt3t1dJswedTrLQg8rRrQZIwqkG+UcYOAL
 UUbVSXm6YFIUW0G9L1pP9PRe2jh1JHp2K6JkqfzzoxgqyGY0xFVdB9g3es5XC0kMI7+E
 H8BUK9eTFgRUvx9uHRExMYY3nN6MRkG6zuvLBIsId4+fsmmpyveHDurLz0Ob3qlX6Ifv
 TrKrIbKFVZLokZPA5QQPc3ql9abG5nJZPC9GvXBR47TR81yBT3OmUsDjRAvV8Wh3GYCZ WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393b1fwm03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 04:01:11 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15A7rMRC190221;
        Thu, 10 Jun 2021 04:01:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393b1fwky2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 04:01:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15A7rFpT022910;
        Thu, 10 Jun 2021 08:01:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3900w8an8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 08:01:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15A80GlY18022870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 08:00:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA4B34C05E;
        Thu, 10 Jun 2021 08:01:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89A114C046;
        Thu, 10 Jun 2021 08:01:03 +0000 (GMT)
Received: from [9.85.116.42] (unknown [9.85.116.42])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 08:01:03 +0000 (GMT)
Subject: Re: [RFC] powerpc/pseries: Interface to represent PAPR firmware
 attributes
To:     Fabiano Rosas <farosas@linux.ibm.com>, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, pratik.r.sampat@gmail.com
References: <20210604163501.51511-1-psampat@linux.ibm.com>
 <87wnr4uhs9.fsf@linux.ibm.com>
 <5c9cb57b-e9d8-0361-8be7-60dc9618db34@linux.ibm.com>
 <87tum6vb58.fsf@linux.ibm.com>
From:   Pratik Sampat <psampat@linux.ibm.com>
Message-ID: <4fae49c3-427a-90f3-faa0-033e8c32e336@linux.ibm.com>
Date:   Thu, 10 Jun 2021 13:31:02 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87tum6vb58.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UC7xVp6sRBn1pZo3GC0u0yNaYkFMiMxh
X-Proofpoint-GUID: 4UsivWPw-8dEPMjunDgB2m3imWvkqESy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_03:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100048
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 10/06/21 5:33 am, Fabiano Rosas wrote:
> Pratik Sampat <psampat@linux.ibm.com> writes:
>
>>>> 3. version info                      - 1 byte
>>>> 4. A data array of size num attributes, which contains the following:
>>>>     a. attribute ID              - 8 bytes
>>>>     b. attribute value in number - 8 bytes
>>>>     c. attribute name in string  - 64 bytes
>>>>     d. attribute value in string - 64 bytes
>>> Is this new hypercall already present in the spec? These seem a bit
>>> underspecified to me.
>> Yes, it is present in the spec. I probably summarized a little more than needed
>> here and I could expand upon below.
>>
>> The input buffer recives the following data:
>>
>> 1. “flags”:
>> 	a. Bit 0: singleAttribute
>> 		If set to 1, only return the single attribute matching firstAttributeId.
>> 	b. Bits 1-63: Reserved
>> 2. “firstAttributeId”: The first attribute to retrieve
>> 3. “bufferAddress”: The logical real address of the start of the output buffer
>> 4. “bufferSize”: The size in bytes of the output buffer
>> 	
>>
>>   From the document, the format of the output buffer is as follows:
>>
>> Table 1 --> output buffer
>> ================================================================================
>> | Field Name           | Byte   | Length   |  Description
>> |                      | Offset | in Bytes |
>> ================================================================================
>> | NumberOf             |        |          | Number of Attributes in Buffer
>> | AttributesInBuffer   | 0x000  | 0x08     |
>> --------------------------------------------------------------------------------
>> | AttributeArrayOffset | 0x008  | 0x08     | Byte offset to start of Array
>> |                      |        |          | of Attributes
>> |                      |        |          |
>> --------------------------------------------------------------------------------
>> | OutputBufferData     |        |          | Version of the Header.
>> | HeaderVersion        | 0x010  | 0x01     | The header will be always
>> | AttributesInBuffer   |        |          | backward compatible, and changes
>> |                      |        |          | will not impact the Array of
>> |                      |        |          | attributes.
>> |                      |        |          | Current version = 0x01
> This is not clear to me. In the event of a header version change, is the
> total set of attributes guaranteed to remain the same? Or only the array
> layout? We might not need to expose the version information after all.

I believe, the way versioning currently works is that if any new attribute is
added/modified to the list, this will entail a new version.

Regardless, the older attributes and their ids will not change and will still
be backwards compatible.

If the versioning does change, this patch does introduce a version check and
will fail to populate the sysfs and, a tool like powerpc-utils will not read
incorrect/non-coherent information.

So I'm inclined also believe now that verisoning information may not be needed
to expose to userspace.

>> --------------------------------------------------------------------------------
>> | ArrayOfAttributes    |        |          | The array will contain
>> |                      |        |          | "NumberOfAttributesInBuffer"
>> |                      |        |          | array elements not to exceed
>> |                      |        |          | the size of the buffer.
>> |                      |        |          | Layout of the array is
>> |                      |        |          | detailed in Table 2.
>> --------------------------------------------------------------------------------
>>
>>
>> Table 2 --> Array of attributes
>> ================================================================================
>> | Field Name           | Byte   | Length   |  Description
>> |                      | Offset | in Bytes |
>> ================================================================================
>> | 1st AttributeId      | 0x000  | 0x08     | The ID of the Attribute
>> --------------------------------------------------------------------------------
>> | 1st AttributeValue   | 0x008  | 0x08     | The numerical value of
>> |                      |        |          | the attribute
>> --------------------------------------------------------------------------------
>> | 1st AttributeString  | 0x010  | 0x40     | The ASCII string
>> | Description          |        |          | description of the
>> |                      |        |          | attribute, up to 63
>> |                      |        |          | characters plus a NULL
>> |                      |        |          | terminator.
> There is a slight disconnect in that this is called "description" by the
> spec, which makes me think they could eventually have something more
> verbose than what you'd expect from "name".
>
> So they could give us either: "Frequency" or "The Frequency in GigaHertz".

Yes, the description can be more verbose, like I can see attributes with the
description as "Minimum Frequency (MHz)". That's probably why parsing based on
IDs is a better approach.

>
>> --------------------------------------------------------------------------------
>> | 1st AttributeValue   | 0x050  | 0x40     | The ASCII string
>> | StringDescription    |        |          | description of the
>> |                      |        |          | attribute value, up to 63
>> |                      |        |          | characters plus a NULL
>> |                      |        |          | terminator. If this
>> |                      |        |          | contains only a NULL
>> |                      |        |          | terminator, then there is
>> |                      |        |          | no ASCII string
>> |                      |        |          | associated with AttributeValue.
>> --------------------------------------------------------------------------------
>> | ....                 |        |          |
>>
>>
>>>> The new H_CALL exports information in direct string value format, hence
>>>> a new interface has been introduced in /sys/firmware/papr to export
>>> Hm.. Maybe this should be something less generic than "papr"?
>> The interface naming was inspired from /sys/firmware/opal's naming convention.
>> We believed the name PAPR could serve as more generic name to be used by both
>> Linux running on PHYP and linux on KVM.
> Right, I agree with that rationale, but /opal has identifiable elements
> in it whereas /papr would have the generic "attr_X_name", which does not
> give much hint about what they are.
>
> We also expect people to iterate the "attr_X_*" files, so if we decide
> to add something else under /papr in the future, that would potentially
> cause issues with any tool that just lists the content of the directory.
>
> So maybe we should be proactive and put the hcall stuff inside a
> subdirectory already. /papr/energy_scale_attrs comes to mind, but I
> don't have a strong opinion on the particular name.

Encapsulating it within another directory like energy_scale_attrs does make
sense and keeps the PAPR directory open to more such information going forward.

>> If you have something more concrete in mind, please let me know. I'm open to
>> suggestions.
>>
>>>> this information to userspace in an extensible pass-through format.
>>>> The H_CALL returns the name, numeric value and string value. As string
>>>> values are in human readable format, therefore if the string value
>>>> exists then that is given precedence over the numeric value.
>>> So the hypervisor could simply not send the string representation? How
>>> will the userspace tell the difference since they are reading everything
>>> from a file?
>>>
>>> Overall I'd say we should give the data in a more structured way and let
>>> the user-facing tool do the formatting and presentation.
>> That's a valid concern, the design for this was inspired from hwmon's interface
>> to housing the sensor information.
>>
>> One alternative to add more structure to this format could be to introduce:
>> attr_X_name, attr_X_num_val, attr_X_str_val
>>
>> However, in some cases like min/max frequency the string value is empty. In
>> that case the file attr_X_str_val will also be empty.
>> Is that an acceptable format of having empty files that in some cases will
>> never be populated?
> I'm thinking yes, but I'm not sure. Let's see if someone else has a say
> in this.

Sure, if we can have empty sysfs files, then this presents a coherent interface.

@mpe, can you weigh in here, can we have an interface where we have the following structure:
/sys/firmware/papr/energy_scale_attrs/
    |-- <id>/
      |-- desc
      |-- value
      |-- value_desc
where value_desc can be empty in some case?
If so, can we leave them empty or do we need to have them populated with a
string "NULL"/"NONE"?

>
>> We also went ahead to confirm with the SPEC team that if a string value exists
>> in their buffer, that must be given precedence.
> Huh.. That must be a recommendation only. The hypervisor has no control
> over how people present the information in userspace.
>
>> Another alternative format could to keep attr_X_name, attr_X_val intact but
>> change what X means. Currently X is just an iteratively increasing number. But
>> X can also serve as an ID which we get from H_CALL output buffer.
> This seems like a good idea. It makes it easier to correlate the
> attribute with what is in PAPR.
>
>> In this case, we should also include some versioning so that the tool now also
>> has cognizance of contents of each file.
>>
>>>> The format of exposing the sysfs information is as follows:
>>>> /sys/firmware/papr/
>>>>     |-- attr_0_name
>>>>     |-- attr_0_val
>>>>     |-- attr_1_name
>>>>     |-- attr_1_val
>>>> ...
>>> How do we keep a stable interface with userspace? Say the hypervisor
>>> decides to add or remove attributes, change their order, string
>>> representation, etc? It will inform us via the version field, but that
>>> is lost when we output this to sysfs.
>>>
>>> I get that if the userspace just iterate over the contents of the
>>> directory then nothing breaks, but there is not much else it could do it
>>> seems.
>> Fair point, having the version exposed to the sysfs does seem crucial.
>>
>> Currently in ppc-utils we iterate over all the information, however as you
>> rightly pointed out there may be other tools needing just specific information.
>> The alternative I suggested a few sentences above to include ID based attribute
>> naming and versioning maybe a more elegant way of solving this problem.
>>
>> What are your thoughts on a design like this?
>>
> Based on all the new information you provided, I'd say present all the
> data and group it under the ID:
>
> /sys/firmware/papr/energy_scale_attrs/
>     |-- <id>/
>       |-- desc
>       |-- value
>       |-- value_desc
>     |-- <id>/
>       |-- desc
>       |-- value
>       |-- value_desc
>
> Is that workable?

If we can confirm if value descriptions can be empty, then I too think this is
a good interface to introduce for energy attributes.

Thanks for your feedback.
Pratik

>>>> The energy information that is exported is useful for userspace tools
>>>> such as powerpc-utils. Currently these tools infer the
>>>> "power_mode_data" value in the lparcfg, which in turn is obtained from
>>>> the to be deprecated H_GET_EM_PARMS H_CALL.
>>>> On future platforms, such userspace utilities will have to look at the
>>>> data returned from the new H_CALL being populated in this new sysfs
>>>> interface and report this information directly without the need of
>>>> interpretation.
>>>>
>>>> Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
>> Thanks
>> Pratik

