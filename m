Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED7E2D52CA
	for <lists+kvm-ppc@lfdr.de>; Thu, 10 Dec 2020 05:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgLJEZc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Dec 2020 23:25:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729536AbgLJEZU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Dec 2020 23:25:20 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BA42fFB099229;
        Wed, 9 Dec 2020 23:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=6VzA0bXuz72kczdUrPJE0gfgD0jew8ofGOPNyWUXFsY=;
 b=KzVuWbSwzIVzAqPxQ0587O8EHKaUmJdZkysv6X6T/cpnDzEjOsMT8unyVRAOvGhvgOhp
 FhkIX0nb4lHFuDkDNNBNMuz+BbkMUvx5s7GFvh8POfHBPcjCF0b7IBn02sNEIXYEDYGY
 xB+P5CFoGKujN1alnrm12N/KrwHRGeK7t77nskgTxut3/3hWtetzN50XdEy3gNGtLlcO
 ODObct6Pgv5p7gcIkLDvo9gntSh7ICKkAcHloMvwNIrcOhfFtKpABkkr1Usff37p2yaD
 jwdPlHSyL6ITUXNkYL59wndKwlAy0Y2MqNE96v7Ia/T0PCmkAOVjTQ+FU22fIAuHuh+k Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35b6b58t8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 23:24:26 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BA42gRK099316;
        Wed, 9 Dec 2020 23:24:26 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35b6b58t81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 23:24:26 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BA4OOWf001404;
        Thu, 10 Dec 2020 04:24:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3581fhjrw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 04:24:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BA4OMFq23724468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 04:24:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 029CFA404D;
        Thu, 10 Dec 2020 04:24:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D22A4053;
        Thu, 10 Dec 2020 04:24:20 +0000 (GMT)
Received: from in.ibm.com (unknown [9.77.203.190])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Dec 2020 04:24:20 +0000 (GMT)
Date:   Thu, 10 Dec 2020 09:54:18 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201210042418.GA775394@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
 <20201209041542.GA29825@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209041542.GA29825@thinks.paulus.ozlabs.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_01:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=1 adultscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100023
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Dec 09, 2020 at 03:15:42PM +1100, Paul Mackerras wrote:
> On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> > Implements H_RPT_INVALIDATE hcall and supports only nested case
> > currently.
> > 
> > A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> > support for this hcall.
> 
> I have a couple of questions about this patch:
> 
> 1. Is this something that is useful today, or is it something that may
> become useful in the future depending on future product plans? In
> other words, what advantage is there to forcing L2 guests to use this
> hcall instead of doing tlbie themselves?

H_RPT_INVALIDATE will replace the use of the existing H_TLB_INVALIDATE
for nested partition scoped invalidations. Implementations that want to
off-load invalidations to the host (when GTSE=0) would have to bother
about only one hcall (H_RPT_INVALIDATE)

> 
> 2. Why does it need to be added to the default-enabled hcall list?
> 
> There is a concern that if this is enabled by default we could get the
> situation where a guest using it gets migrated to a host that doesn't
> support it, which would be bad.  That is the reason that all new
> things like this are disabled by default and only enabled by userspace
> (i.e. QEMU) in situations where we can enforce that it is available on
> all hosts to which the VM might be migrated.

As you suggested privately, I am thinking of falling back to
H_TLB_INVALIDATE in case where this new hcall fails due to not being
present. That should address the migration case that you mention
above. With that and leaving the new hcall enabled by default
is good okay?

Regards,
Bharata.
