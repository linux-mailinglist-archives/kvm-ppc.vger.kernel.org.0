Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECEF178401
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 21:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgCCU3c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 15:29:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731014AbgCCU3c (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 15:29:32 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023KLlWC076238
        for <kvm-ppc@vger.kernel.org>; Tue, 3 Mar 2020 15:29:32 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfhqrdp1h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 03 Mar 2020 15:29:31 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Tue, 3 Mar 2020 20:29:29 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 20:29:25 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 023KTNvN40042600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 20:29:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2292AE051;
        Tue,  3 Mar 2020 20:29:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61FE6AE045;
        Tue,  3 Mar 2020 20:29:21 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.197.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  3 Mar 2020 20:29:21 +0000 (GMT)
Date:   Tue, 3 Mar 2020 12:29:18 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
 <6f7ea308-3505-6070-dde1-20fee8fdddc3@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f7ea308-3505-6070-dde1-20fee8fdddc3@kaod.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20030320-0020-0000-0000-000003B0321B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030320-0021-0000-0000-00002208633F
Message-Id: <20200303202918.GC5416@oc0525413822.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=347
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030130
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 03, 2020 at 08:08:51PM +0100, C�dric Le Goater wrote:
> >>>   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
> >>>      to write to event queues in guest memory, which would have to be
> >>>      explicitly shared for secure mode.  That's true whether it's KVM
> >>>      or qemu accessing the guest memory, so kernel_irqchip=on/off is
> >>>      entirely irrelevant.
> >>
> >> This problem should be already fixed.
> >> The XIVE event queues are shared 
> >  	
> > Yes i have a patch for the guest kernel that shares the event 
> > queue page with the hypervisor. This is done using the
> > UV_SHARE_PAGE ultracall. This patch is not sent out to any any mailing
> > lists yet. However the patch by itself does not solve the xive problem
> > for secure VM.
> 
> yes because you also need to share the XIVE TIMA and ESB pages mapped 
> in xive_native_esb_fault() and xive_native_tima_fault(). 

These pages belong to the xive memory slot right? If that is the case,
they are implicitly shared. The Ultravisor will set them up to be
shared. The guest kernel should not be doing anything.

We still need some fixes in KVM and Ultravisor to correctly map the
hardware pages to GPA ranges of the xive memory slot. Work is in progress...



> 
> >> and the remaining problem with XIVE is the KVM page fault handler 
> >> populating the TIMA and ESB pages. Ultravisor doesn't seem to support
> >> this feature and this breaks interrupt management in the guest. 
> > 
> > Yes. This is the bigger issue that needs to be fixed. When the secure guest
> > accesses the page associated with the xive memslot, a page fault is
> > generated, which the ultravisor reflects to the hypervisor. Hypervisor
> > seems to be mapping Hardware-page to that GPA. Unforatunately it is not
> > informing the ultravisor of that map.  I am trying to understand the
> > root cause. But since I am not sure what more issues I might run into
> > after chasing down that issue, I figured its better to disable xive
> > support in SVM in the interim.
> 
> Is it possible to call uv_share_page() from the hypervisor ? 

No. Not allowed. If allowed hypervisor can easily attack the SVM.

> 
> > **** BTW: I figured, I dont need this intermin patch to disable xive for
> > secure VM.  Just doing "svm=on xive=off" on the kernel command line is
> > sufficient for now. *****
> 
> Yes. 
> 
> >> But, kernel_irqchip=off should work out of the box. It seems it doesn't. 
> >> Something to investigate.
> > 
> > Dont know why. 
> 
> We need to understand why. 
> 
> You still need the patch to share the event queue page allocated by the 
> guest OS because QEMU will enqueue events. But you should not need anything
> else.

ok. that is assuring.

> 
> > Does this option, disable the chip from interrupting the
> > guest directly; instead mediates the interrupt through the hypervisor?
> 
> Yes. The KVM backend is unused, the XIVE interrupt controller is deactivated
> for the guest and QEMU notifies the vCPUs directly.  
> 
> The TIMA and ESB pages belong the QEMU process and the guest OS will do 
> some load and store operations onto them for interrupt management. Is that 
> OK from a UV perspective ?  

Yes. These GPA ranges are needed; by design, to be read/writable from qemu/KVM and
the SVM. Just that the implementation in its current form, needs some
fixing.

RP

