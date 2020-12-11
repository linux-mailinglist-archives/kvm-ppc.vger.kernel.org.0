Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DF2D73FB
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Dec 2020 11:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388682AbgLKKej (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Dec 2020 05:34:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727680AbgLKKeg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 11 Dec 2020 05:34:36 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBA5ceg036311;
        Fri, 11 Dec 2020 05:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=KgLxMkEJ8BV3d0OFbuBTbEdL+9Q4/ypB1NhM9lOYIYI=;
 b=d9NHIH1qYqoNfB1Ywo7QR5QEI4iOJ1gssX6NDVyrG9i9WgizOQLfPXcg6nQ+sIl5xnL6
 Ucj8z/LzdvW+LFDoF+q7st9H+/anSUqTA9lafXyXzW7NQMez2EmShbC0H8CtuN4xzIyq
 /SCVBVw01y2aCeW33QxPy/Kmvd2uRpEx+0urhboOtFzf+WD0F8CfI+YW62XKYxkQgSxU
 VG1p7yk9fxMcn4e9kB/X0CNdMuWZuEbhPY77Cc+ENyL51lfPTPXFYFCu+8+R6EJy0qRe
 j9RmzaqYDvuZYAX+QmsVUrIYS2e7Z5e0QhP8/LPB0INVSGBlKmQ0HnrPOmT0YzxUk1t0 bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6cwh3cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:33:48 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBA5m8q036580;
        Fri, 11 Dec 2020 05:33:47 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6cwh3ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:33:47 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBATj5T028822;
        Fri, 11 Dec 2020 10:33:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 35958q2nj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:33:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBAXeS960162482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:33:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEA65AE055;
        Fri, 11 Dec 2020 10:33:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A57A1AE045;
        Fri, 11 Dec 2020 10:33:38 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.57.136])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Dec 2020 10:33:38 +0000 (GMT)
Date:   Fri, 11 Dec 2020 16:03:36 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201211103336.GB775394@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019112642.53016-2-bharata@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=1 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110061
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> Implements H_RPT_INVALIDATE hcall and supports only nested case
> currently.
> 
> A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> support for this hcall.

As Paul mentioned in the thread, this hcall does both process scoped
invalidations and partition scoped invalidations for L2 guest.
I am adding KVM_CAP_RPT_INVALIDATE capability with only partition
scoped invalidations (nested case) implemented in the hcall as we
don't see the need for KVM to implement process scoped invalidation
function as KVM may never run with LPCR[GTSE]=0.

I am wondering if enabling the capability with only partial
implementation of the hcall is the correct thing to do. In future
if we ever want process scoped invalidations support in this hcall,
we may not be able to differentiate the availability of two functions
cleanly from QEMU.

So does it make sense to implement the process scoped invalidation
function also now itself even if it is not going to be used in
KVM?

Regards,
Bharata.
