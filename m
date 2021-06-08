Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBC73A06A4
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 00:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFHWPk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Jun 2021 18:15:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhFHWPj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Jun 2021 18:15:39 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158M2tGi061733;
        Tue, 8 Jun 2021 18:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=I8UeexVBftFIHcN4eHUtmb0QUMZ+zM2riYOS1N7AGhI=;
 b=hE/3sN7PTY7eIEBqJnDlMY8IzgvVbxp4XBHj8fV4llYYBjbijNxjieIzg+D+mWURwV2u
 Fde3Ac1TY0sg2vlkDfEacPj2SpPU3NwMJ7ARWEHHmE9Yc1xIElesqappzrB5No4CcWYy
 gksXEusvSjvYkDDlYBQnGKstwIZHIcgUsajSe4NpnYAewIGFTJan8waSV+hz10zlhmn0
 m5k7lFTlYqxEKikikXJmFDoOh0nv0SX3gLaH1iXgAQfIZCF1aZ5pinwNqQJe/kyVFBxF
 CLsGjwoxSfHTH5OK1YRHdjZGH2BUjKznoFt8C+EWeQhtIedI19pJuTrYll6z/8j+4Xhr ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392gees2np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:13:16 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158M40R3068180;
        Tue, 8 Jun 2021 18:13:15 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392gees2n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:13:15 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158MBcG0009786;
        Tue, 8 Jun 2021 22:13:14 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3900w9heyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 22:13:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158MDD1X22217048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 22:13:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CAC578F8D;
        Tue,  8 Jun 2021 22:13:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96D1B78F93;
        Tue,  8 Jun 2021 22:13:12 +0000 (GMT)
Received: from localhost (unknown [9.211.119.158])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Jun 2021 22:13:12 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     "Pratik R. Sampat" <psampat@linux.ibm.com>, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: Re: [RFC] powerpc/pseries: Interface to represent PAPR firmware
 attributes
In-Reply-To: <20210604163501.51511-1-psampat@linux.ibm.com>
References: <20210604163501.51511-1-psampat@linux.ibm.com>
Date:   Tue, 08 Jun 2021 19:13:10 -0300
Message-ID: <87wnr4uhs9.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PDJPruRKnqmTKQaAyoaG53GaLdYzRp0y
X-Proofpoint-ORIG-GUID: SjAwTyOBxJnaylpvTCuLhl3pO4NXFKZy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_17:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080137
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

"Pratik R. Sampat" <psampat@linux.ibm.com> writes:

Hi, I have some general comments and questions, mostly trying to
understand design of the hcall and use cases of the sysfs data:

> Adds a generic interface to represent the energy and frequency related
> PAPR attributes on the system using the new H_CALL
> "H_GET_ENERGY_SCALE_INFO".
>
> H_GET_EM_PARMS H_CALL was previously responsible for exporting this
> information in the lparcfg, however the H_GET_EM_PARMS H_CALL
> will be deprecated P10 onwards.
>
> The H_GET_ENERGY_SCALE_INFO H_CALL is of the following call format:
> hcall(
>   uint64 H_GET_ENERGY_SCALE_INFO,  // Get energy scale info
>   uint64 flags,           // Per the flag request
>   uint64 firstAttributeId,// The attribute id
>   uint64 bufferAddress,   // The logical address of the output buffer

Instead of logical address, guest address or guest physical address
would be more precise.

>   uint64 bufferSize       // The size in bytes of the output buffer
> );
>
> This H_CALL can query either all the attributes at once with
> firstAttributeId = 0, flags = 0 as well as query only one attribute
> at a time with firstAttributeId = id
>
> The output buffer consists of the following
> 1. number of attributes              - 8 bytes
> 2. array offset to the data location - 8 bytes

The offset is from the start of the buffer, isn't it? So not the array
offset.

> 3. version info                      - 1 byte
> 4. A data array of size num attributes, which contains the following:
>   a. attribute ID              - 8 bytes
>   b. attribute value in number - 8 bytes
>   c. attribute name in string  - 64 bytes
>   d. attribute value in string - 64 bytes

Is this new hypercall already present in the spec? These seem a bit
underspecified to me.

>
> The new H_CALL exports information in direct string value format, hence
> a new interface has been introduced in /sys/firmware/papr to export

Hm.. Maybe this should be something less generic than "papr"?

> this information to userspace in an extensible pass-through format.
> The H_CALL returns the name, numeric value and string value. As string
> values are in human readable format, therefore if the string value
> exists then that is given precedence over the numeric value.

So the hypervisor could simply not send the string representation? How
will the userspace tell the difference since they are reading everything
from a file?

Overall I'd say we should give the data in a more structured way and let
the user-facing tool do the formatting and presentation.

>
> The format of exposing the sysfs information is as follows:
> /sys/firmware/papr/
>   |-- attr_0_name
>   |-- attr_0_val
>   |-- attr_1_name
>   |-- attr_1_val
> ...

How do we keep a stable interface with userspace? Say the hypervisor
decides to add or remove attributes, change their order, string
representation, etc? It will inform us via the version field, but that
is lost when we output this to sysfs.

I get that if the userspace just iterate over the contents of the
directory then nothing breaks, but there is not much else it could do it
seems.

>
> The energy information that is exported is useful for userspace tools
> such as powerpc-utils. Currently these tools infer the
> "power_mode_data" value in the lparcfg, which in turn is obtained from
> the to be deprecated H_GET_EM_PARMS H_CALL.
> On future platforms, such userspace utilities will have to look at the
> data returned from the new H_CALL being populated in this new sysfs
> interface and report this information directly without the need of
> interpretation.
>
> Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
