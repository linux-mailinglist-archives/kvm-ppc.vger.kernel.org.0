Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7FF6EC1
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Nov 2019 07:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfKKGzh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Nov 2019 01:55:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30994 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfKKGzh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 Nov 2019 01:55:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAB6pqnh161941
        for <kvm-ppc@vger.kernel.org>; Mon, 11 Nov 2019 01:55:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w5s554aae-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 11 Nov 2019 01:55:35 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Mon, 11 Nov 2019 06:55:33 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 06:55:30 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAB6tSXt62521470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 06:55:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98A44A406B;
        Mon, 11 Nov 2019 06:55:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C994AA4065;
        Mon, 11 Nov 2019 06:55:25 +0000 (GMT)
Received: from in.ibm.com (unknown [9.109.247.23])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Nov 2019 06:55:25 +0000 (GMT)
Date:   Mon, 11 Nov 2019 12:25:22 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 6/8] KVM: PPC: Support reset of secure guest
Reply-To: bharata@linux.ibm.com
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-7-bharata@linux.ibm.com>
 <20191111052806.GC4017@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111052806.GC4017@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19111106-0028-0000-0000-000003B4CE29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111106-0029-0000-0000-00002477D4AF
Message-Id: <20191111065522.GH21634@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110066
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 11, 2019 at 04:28:06PM +1100, Paul Mackerras wrote:
> On Mon, Nov 04, 2019 at 09:47:58AM +0530, Bharata B Rao wrote:
> > Add support for reset of secure guest via a new ioctl KVM_PPC_SVM_OFF.
> > This ioctl will be issued by QEMU during reset and includes the
> > the following steps:
> > 
> > - Ask UV to terminate the guest via UV_SVM_TERMINATE ucall
> > - Unpin the VPA pages so that they can be migrated back to secure
> >   side when guest becomes secure again. This is required because
> >   pinned pages can't be migrated.
> 
> Unpinning the VPA pages is normally handled during VM reset by QEMU
> doing set_one_reg operations to set the values for the
> KVM_REG_PPC_VPA_ADDR, KVM_REG_PPC_VPA_SLB and KVM_REG_PPC_VPA_DTL
> pseudo-registers to zero.  Is there some reason why this isn't
> happening for a secure VM, and if so, what is that reason?
> If it is happening, then why do we need to unpin the pages explicitly
> here?

We were observing these VPA pages still remaining pinned during
reset and hence subsequent paging-in of these pages were failing.
Unpinning them fixed the problem.

I will investigate and get back on why exactly these pages weren't
gettting unpinned normally as part of reset.

> 
> > - Reinitialize guest's partitioned scoped page tables. These are
> >   freed when guest becomes secure (H_SVM_INIT_DONE)
> 
> It doesn't seem particularly useful to me to free the partition-scoped
> page tables when the guest becomes secure, and it feels like it makes
> things more fragile.  If you don't free them then, then you don't need
> to reallocate them now.

Sure, I will not free them in the next version.

Regards,
Bharata.

