Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736E1782A3
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 20:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgCCS5B (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 13:57:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729988AbgCCS5A (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 13:57:00 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023IpIce119159
        for <kvm-ppc@vger.kernel.org>; Tue, 3 Mar 2020 13:56:59 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yhpwm0m4e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 03 Mar 2020 13:56:58 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Tue, 3 Mar 2020 18:56:57 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 18:56:53 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 023IupmY54132936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 18:56:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 826CBA4054;
        Tue,  3 Mar 2020 18:56:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC2CA405F;
        Tue,  3 Mar 2020 18:56:48 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.197.107])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  3 Mar 2020 18:56:48 +0000 (GMT)
Date:   Tue, 3 Mar 2020 10:56:45 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@fr.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
 <20200303184520.632be270@bahia.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200303184520.632be270@bahia.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20030318-0012-0000-0000-0000038CDC2A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030318-0013-0000-0000-000021C993AE
Message-Id: <20200303185645.GB5416@oc0525413822.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030124
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 03, 2020 at 06:45:20PM +0100, Greg Kurz wrote:
> On Tue, 3 Mar 2020 09:02:05 -0800
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > On Tue, Mar 03, 2020 at 07:50:08AM +0100, Cédric Le Goater wrote:
> > > On 3/3/20 12:32 AM, David Gibson wrote:
> > > > On Fri, Feb 28, 2020 at 11:54:04PM -0800, Ram Pai wrote:
> > > >> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
> > > >>
> > > >> Hence Secure VM, must always default to XICS interrupt controller.
> > > >>
> > > >> If XIVE is requested through kernel command line option "xive=on",
> > > >> override and turn it off.
> > > >>
> > > >> If XIVE is the only supported platform interrupt controller; specified
> > > >> through qemu option "ic-mode=xive", simply abort. Otherwise default to
> > > >> XICS.
> > > > 
> > > > Uh... the discussion thread here seems to have gotten oddly off
> > > > track.  
> > > 
> > > There seem to be multiple issues. It is difficult to have a clear status.
> > > 
> > > > So, to try to clean up some misunderstandings on both sides:
> > > > 
> > > >   1) The guest is the main thing that knows that it will be in secure
> > > >      mode, so it's reasonable for it to conditionally use XIVE based
> > > >      on that
> > > 
> > > FW support is required AFAIUI.
> > > >   2) The mechanism by which we do it here isn't quite right.  Here the
> > > >      guest is checking itself that the host only allows XIVE, but we
> > > >      can't do XIVE and is panic()ing.  Instead, in the SVM case we
> > > >      should force support->xive to false, and send that in the CAS
> > > >      request to the host.  We expect the host to just terminate
> > > >      us because of the mismatch, but this will interact better with
> > > >      host side options setting policy for panic states and the like.
> > > >      Essentially an SVM kernel should behave like an old kernel with
> > > >      no XIVE support at all, at least w.r.t. the CAS irq mode flags.
> > > 
> > > Yes. XIVE shouldn't be requested by the guest.
> > 
> > 	Ok.
> > 
> > > This is the last option 
> > > I proposed but I thought there was some negotiation with the hypervisor
> > > which is not the case. 
> > > 
> > > >   3) Although there are means by which the hypervisor can kind of know
> > > >      a guest is in secure mode, there's not really an "svm=on" option
> > > >      on the host side.  For the most part secure mode is based on
> > > >      discussion directly between the guest and the ultravisor with
> > > >      almost no hypervisor intervention.
> > > 
> > > Is there a negotiation with the ultravisor ? 
> > 
> > 	The VM has no negotiation with the ultravisor w.r.t CAS.
> > 
> > > 
> > > >   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
> > > >      to write to event queues in guest memory, which would have to be
> > > >      explicitly shared for secure mode.  That's true whether it's KVM
> > > >      or qemu accessing the guest memory, so kernel_irqchip=on/off is
> > > >      entirely irrelevant.
> > > 
> > > This problem should be already fixed.
> > > The XIVE event queues are shared 
> >  	
> > Yes i have a patch for the guest kernel that shares the event 
> > queue page with the hypervisor. This is done using the
> > UV_SHARE_PAGE ultracall. This patch is not sent out to any any mailing
> > lists yet.
> 
> Why ?

At this point I am not sure if this is the only change, I need to the
guest kernel.  I also need changes to KVM and to the ultravisor. Its bit
premature to send the patch without having figured out everything
to get xive working on a Secure VM.

> 
> > However the patch by itself does not solve the xive problem
> > for secure VM.
> > 
> 
> This patch would allow at least to answer Cedric's question about
> kernel_irqchip=off, since this looks like the only thing needed
> to make it work.

hmm.. I am not sure. Are you saying
(a) patch the guest kernel to share the event queue page
(b) run the qemu with "kernel_irqchip=off"
(c) and the guest kernel with "svm=on"

and it should all work?

RP

