Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587CD1749DF
	for <lists+kvm-ppc@lfdr.de>; Sat, 29 Feb 2020 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgB2Wvx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 29 Feb 2020 17:51:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726786AbgB2Wvw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 29 Feb 2020 17:51:52 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01TMoCXB038379
        for <kvm-ppc@vger.kernel.org>; Sat, 29 Feb 2020 17:51:51 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yfmyp677d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 29 Feb 2020 17:51:51 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Sat, 29 Feb 2020 22:51:49 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 29 Feb 2020 22:51:47 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01TMpj7M57344000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 22:51:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B39852054;
        Sat, 29 Feb 2020 22:51:45 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.192.224])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8B5285204E;
        Sat, 29 Feb 2020 22:51:43 +0000 (GMT)
Date:   Sat, 29 Feb 2020 14:51:40 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        aik@ozlabs.ru, andmike@linux.ibm.com, groug@kaod.org,
        clg@fr.ibm.com, sukadev@linux.vnet.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <1e28fb80-7bae-8d80-1a72-f616af030aab@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e28fb80-7bae-8d80-1a72-f616af030aab@kaod.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20022922-0012-0000-0000-0000038B8C85
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022922-0013-0000-0000-000021C83BEC
Message-Id: <20200229225140.GA5618@oc0525413822.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 malwarescore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290177
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Feb 29, 2020 at 09:27:54AM +0100, Cédric Le Goater wrote:
> On 2/29/20 8:54 AM, Ram Pai wrote:
> > XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
> > 
> > Hence Secure VM, must always default to XICS interrupt controller.
> 
> have you tried XIVE emulation 'kernel-irqchip=off' ? 

yes and it hangs. I think that option, continues to enable some variant
of XIVE in the VM.  There are some known deficiencies between KVM
and the ultravisor negotiation, resulting in a hang in the SVM.

> 
> > If XIVE is requested through kernel command line option "xive=on",
> > override and turn it off.
> 
> This is incorrect. It is negotiated through CAS depending on the FW
> capabilities and the KVM capabilities.

Yes I understand, qemu/KVM have predetermined a set of capabilties that
it can offer to the VM.  The kernel within the VM has a list of
capabilties it needs to operate correctly.  So both negotiate and
determine something mutually ammicable.

Here I am talking about the list of capabilities that the kernel is
trying to determine, it needs to operate correctly.  "xive=on" is one of
those capabilities the kernel is told by the VM-adminstrator, to enable.
Unfortunately if the VM-administrtor blindly requests to enable it, the
kernel must override it, if it knows that will be switching the VM into
a SVM soon. No point negotiating a capability with Qemu; through CAS,
if it knows it cannot handle that capability.

> 
> > If XIVE is the only supported platform interrupt controller; specified
> > through qemu option "ic-mode=xive", simply abort. Otherwise default to
> > XICS.
> 
> 
> I don't think it is a good approach to downgrade the guest kernel 
> capabilities this way. 
> 
> PAPR has specified the CAS negotiation process for this purpose. It 
> comes in two parts under KVM. First the KVM hypervisor advertises or 
> not a capability to QEMU. The second is the CAS negotiation process 
> between QEMU and the guest OS.

Unfortunately, this is not viable.  At the time the hypervisor
advertises its capabilities to qemu, the hypervisor has no idea whether
that VM will switch into a SVM or not.  The decision to switch into a
SVM is taken by the kernel running in the VM. This happens much later,
after the hypervisor has already conveyed its capabilties to the qemu, and
qemu has than instantiated the VM.

As a result, CAS in prom_init is the only place where this negotiation
can take place.

> 
> The SVM specifications might not be complete yet and if some features 
> are incompatible, I think we should modify the capabilities advertised 
> by the hypervisor : no XIVE in case of SVM. QEMU will automatically 
> use the fallback path and emulate the XIVE device, same as setting 
> 'kernel-irqchip=off'. 

As mentioned above, this would be an excellent approach, if the
Hypervisor was aware of the VM's intent to switch into a SVM.  Neither
the hypervisor knows, nor the qemu.  Only the kernel running within the
VM knows about it.


Do you still think, my approach is wrong?
RP

