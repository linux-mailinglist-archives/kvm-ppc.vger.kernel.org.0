Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2534F7A0
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 05:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhCaDuM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Mar 2021 23:50:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232805AbhCaDtv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Mar 2021 23:49:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12V3X2MJ033526;
        Tue, 30 Mar 2021 23:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=UGudfjMlEZLfqlVSDmOnmDyvQ96ap/6ySNEkNaXapKw=;
 b=GTM9yj3DTlZ+CObdWSTnW7Ti60AIpB1DD8bx/5JfermBikCns6FKGLVRq1ETpjXyKxoC
 M3vtxB9eXlFItXnfEhduT3noYYDUM5j9h94OydqzV7Pt1zhOesv4IIx854LMNsO9bnkM
 a78JOmjlRHK3dhFZihAupQ/bQFtANmh6TeKLJscLEKBZzIJcSVWU8AMV+GA7Ggt/vpBp
 ymwW3emIn/WK1EhRswureNr0iADPHJ8rinK+lbdRrBEzf8cQ/7uXgKjxDBjHoC2jFvjZ
 jWy/PLPAAAd8kMwy6cpyxsL70EH2kz6ayKLDKflqmX1HsUYtZZ2BS23OQmLeLFy/ORX+ mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mb4qytu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 23:49:37 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12V3YmCp043540;
        Tue, 30 Mar 2021 23:49:36 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mb4qyttn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 23:49:36 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12V3mcq9030521;
        Wed, 31 Mar 2021 03:49:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 37maaqr4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 03:49:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12V3nCLI19857854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 03:49:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB88F11C058;
        Wed, 31 Mar 2021 03:49:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07B0911C04A;
        Wed, 31 Mar 2021 03:49:28 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.35.103])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 31 Mar 2021 03:49:27 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 31 Mar 2021 09:19:26 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com
Subject: Re: [PATCH] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
In-Reply-To: <YGO488mqe2RMHBiu@yekko.fritz.box>
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
 <20210330161437.45872897@bahia.lan> <87r1jwpo3p.fsf@vajain21.in.ibm.com>
 <YGO488mqe2RMHBiu@yekko.fritz.box>
Date:   Wed, 31 Mar 2021 09:19:26 +0530
Message-ID: <87o8f0oud5.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3l4_Pp94MnAf2UruDvx2Q97Q3CG-PIJJ
X-Proofpoint-ORIG-GUID: Vu5cKAMR9g1BQsQvQjgcVMnbtcKqz1wo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_01:2021-03-30,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103300000 definitions=main-2103310024
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Thanks for looking into this patch,

David Gibson <david@gibson.dropbear.id.au> writes:

<snip>
>> H_SCM_HEALTH specifications is already documented in linux kernel
>> documentation at
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
>
> Putting a reference to that in the commit message would be a good idea.
>
Yes, its already part of v1 patch description as reference [1].

<snip>
>> >
>> > Having access to the excerpts from the PAPR addendum that describes
>> > this hcall would _really_ help in reviewing.
>> >
>> The kernel documentation for H_SCM_HEALTH mentioned above captures most
>> if not all parts of the PAPR addendum for this hcall. I believe it
>> contains enough information to review the patch. If you still need more
>> info than please let me know.
>
> We've missed the qemu-6.0 cutoff, so this will be 6.1 material.  I'll
> await v2 for further review.
>
Agree. Will send a v2 today incorporating current review comments.


-- 
Cheers
~ Vaibhav
