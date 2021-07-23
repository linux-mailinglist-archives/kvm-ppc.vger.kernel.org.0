Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67523D3AF6
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Jul 2021 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbhGWMg3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Jul 2021 08:36:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234988AbhGWMg2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 23 Jul 2021 08:36:28 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16ND3eFX049686;
        Fri, 23 Jul 2021 09:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=UVQt0GuOeKk36RlYZ2dAkgT4CoJbUq2B09fX4wSvrCo=;
 b=EHW0RAUX7yvLTLkInVn0AP/U+4lP4bnMv879AooV+2s5vI/ZzONJRT9ufOQUAX6fCAeI
 MZzG5PgIJLBVfpVDVRDcJcr1wbG6KqDoSzoW39BcT9bVX7Il/6o3wARB8SUdV0GpSplq
 GeMLtqWmLKHM+Ib9OoCSBM+tdKGxiT6qVmVZs4GvD3SRsroe58VOd6OtBR7tIoMqSRay
 9bIhMWRpc2qLudtrDuLNcgr7V+c/fCJ9hZddt4vj3hkutXZCwZqlT5/QDQ+wIEVqNPMd
 64rBs1OeHCQsOMh5ZfO7bru9sUbe6JgVwy9pT1ozXfSwvwj8VOHnCj4Abgv6c9cH42Gp Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yvxwbdj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 09:16:38 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16ND4Sf3053233;
        Fri, 23 Jul 2021 09:16:38 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yvxwbdhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 09:16:37 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16ND74Oa018506;
        Fri, 23 Jul 2021 13:16:37 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 39upufy0a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:16:37 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NDGaEY24051970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 13:16:36 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25914112070;
        Fri, 23 Jul 2021 13:16:36 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5824F112065;
        Fri, 23 Jul 2021 13:16:35 +0000 (GMT)
Received: from localhost (unknown [9.211.138.163])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 23 Jul 2021 13:16:34 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     "Pratik R. Sampat" <psampat@linux.ibm.com>, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, kjain@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: Re: [PATCH v7 1/1] powerpc/pseries: Interface to represent PAPR
 firmware attributes
In-Reply-To: <20210723054609.15033-2-psampat@linux.ibm.com>
References: <20210723054609.15033-1-psampat@linux.ibm.com>
 <20210723054609.15033-2-psampat@linux.ibm.com>
Date:   Fri, 23 Jul 2021 10:16:32 -0300
Message-ID: <87r1fpcgr3.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t4BzyVrfvVSyoZVsVv1DINHFabc5o9M_
X-Proofpoint-GUID: y1d1d4t_xEJ3rGTmbqYl9y8h4rjJ3Z2X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_05:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230078
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

"Pratik R. Sampat" <psampat@linux.ibm.com> writes:

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
>   uint64 bufferAddress,   // Guest physical address of the output buffer
>   uint64 bufferSize       // The size in bytes of the output buffer
> );
>
> This H_CALL can query either all the attributes at once with
> firstAttributeId = 0, flags = 0 as well as query only one attribute
> at a time with firstAttributeId = id, flags = 1.
>
> The output buffer consists of the following
> 1. number of attributes              - 8 bytes
> 2. array offset to the data location - 8 bytes
> 3. version info                      - 1 byte
> 4. A data array of size num attributes, which contains the following:
>   a. attribute ID              - 8 bytes
>   b. attribute value in number - 8 bytes
>   c. attribute name in string  - 64 bytes
>   d. attribute value in string - 64 bytes
>
> The new H_CALL exports information in direct string value format, hence
> a new interface has been introduced in
> /sys/firmware/papr/energy_scale_info to export this information to
> userspace in an extensible pass-through format.
>
> The H_CALL returns the name, numeric value and string value (if exists)
>
> The format of exposing the sysfs information is as follows:
> /sys/firmware/papr/energy_scale_info/
>    |-- <id>/
>      |-- desc
>      |-- value
>      |-- value_desc (if exists)
>    |-- <id>/
>      |-- desc
>      |-- value
>      |-- value_desc (if exists)
> ...
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
> Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

