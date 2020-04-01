Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6783D19A4B8
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Apr 2020 07:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgDAFcO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Apr 2020 01:32:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731589AbgDAFcO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 1 Apr 2020 01:32:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03153O2u074938
        for <kvm-ppc@vger.kernel.org>; Wed, 1 Apr 2020 01:32:13 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303wrwxgvk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 01 Apr 2020 01:32:13 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Wed, 1 Apr 2020 06:32:00 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 06:31:56 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0315V2Jk30605762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 05:31:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78AAD4C040;
        Wed,  1 Apr 2020 05:32:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 262624C04A;
        Wed,  1 Apr 2020 05:32:03 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.175.204])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Apr 2020 05:32:02 +0000 (GMT)
Date:   Tue, 31 Mar 2020 22:32:00 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org, clg@fr.ibm.com, david@gibson.dropbear.id.au
Subject: Re: [PATCH v2] powerpc/XIVE: SVM: share the event-queue page with
 the Hypervisor.
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
 <87r1x86pzw.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1x86pzw.fsf@morokweng.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20040105-0008-0000-0000-000003684423
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040105-0009-0000-0000-00004A89CB08
Message-Id: <20200401053200.GE5903@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010044
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 31, 2020 at 08:53:07PM -0300, Thiago Jung Bauermann wrote:
> 
> Hi Ram,
> 
> Ram Pai <linuxram@us.ibm.com> writes:
> 
> > diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
> > index 55dc61c..608b52f 100644
> > --- a/arch/powerpc/sysdev/xive/spapr.c
> > +++ b/arch/powerpc/sysdev/xive/spapr.c
> > @@ -26,6 +26,8 @@
> >  #include <asm/xive.h>
> >  #include <asm/xive-regs.h>
> >  #include <asm/hvcall.h>
> > +#include <asm/svm.h>
> > +#include <asm/ultravisor.h>
> >  
> >  #include "xive-internal.h"
> >  
> > @@ -501,6 +503,9 @@ static int xive_spapr_configure_queue(u32 target, struct xive_q *q, u8 prio,
> >  		rc = -EIO;
> >  	} else {
> >  		q->qpage = qpage;
> > +		if (is_secure_guest())
> > +			uv_share_page(PHYS_PFN(qpage_phys),
> > +					1 << xive_alloc_order(order));
> 
> If I understand this correctly, you're passing the number of bytes of
> the queue to uv_share_page(), but that ultracall expects the number of
> pages to be shared.


static inline u32 xive_alloc_order(u32 queue_shift)
{
        return (queue_shift > PAGE_SHIFT) ? (queue_shift - PAGE_SHIFT) : 0;
}

xive_alloc_order(order) returns the order of PAGE_SIZE pages.
Hence the value passed to uv_shared_pages is the number of pages,
and not the number of bytes.

BTW: I did verify through testing that it was indeed passing 1 page to the
uv_share_page().  

RP

