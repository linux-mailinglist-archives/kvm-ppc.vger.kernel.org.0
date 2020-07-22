Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89BA22927E
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 09:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgGVHpv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jul 2020 03:45:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8730 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726153AbgGVHpv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jul 2020 03:45:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M7aqUP051630;
        Wed, 22 Jul 2020 03:45:32 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32e1vrh2c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 03:45:32 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06M7ibSQ018028;
        Wed, 22 Jul 2020 07:45:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 32dbmn13pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:45:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06M7jR8023593376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 07:45:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D1F9A4067;
        Wed, 22 Jul 2020 07:45:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CFC9A405C;
        Wed, 22 Jul 2020 07:45:24 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.146.165])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 22 Jul 2020 07:45:24 +0000 (GMT)
Date:   Wed, 22 Jul 2020 00:45:21 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, sathnaga@linux.vnet.ibm.com,
        aik@ozlabs.ru
Message-ID: <20200722074521.GA7361@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
 <20200722050232.GD3878639@thinks.paulus.ozlabs.org>
 <20200722074205.GH7339@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722074205.GH7339@oc0525413822.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO
 access, in sprg0 register
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 mlxlogscore=508 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220052
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 22, 2020 at 12:42:05AM -0700, Ram Pai wrote:
> On Wed, Jul 22, 2020 at 03:02:32PM +1000, Paul Mackerras wrote:
> > On Thu, Jul 16, 2020 at 01:32:13AM -0700, Ram Pai wrote:
> > > An instruction accessing a mmio address, generates a HDSI fault.  This fault is
> > > appropriately handled by the Hypervisor.  However in the case of secureVMs, the
> > > fault is delivered to the ultravisor.
> > > 
> > > Unfortunately the Ultravisor has no correct-way to fetch the faulting
> > > instruction. The PEF architecture does not allow Ultravisor to enable MMU
> > > translation. Walking the two level page table to read the instruction can race
> > > with other vcpus modifying the SVM's process scoped page table.
> > > 
> > > This problem can be correctly solved with some help from the kernel.
> > > 
> > > Capture the faulting instruction in SPRG0 register, before executing the
> > > faulting instruction. This enables the ultravisor to easily procure the
> > > faulting instruction and emulate it.
> > 
> > Just a comment on the approach of putting the instruction in SPRG0:
> > these I/O accessors can be used in interrupt routines, which means
> > that if these accessors are ever used with interrupts enabled, there
> > is the possibility of an external interrupt occurring between the
> > instruction that sets SPRG0 and the load/store instruction that
> > faults.  If the handler for that interrupt itself does an I/O access,
> > it will overwrite SPRG0, corrupting the value set by the interrupted
> > code.
> 
> Acutally my proposed code restores the value of SPRG0 before returning back to
> the interrupted instruction. So here is the sequence. I think it works.
> 
>  (1) store sprg0 in register Rx (lets say srpg0 had 0xc. Rx now contains 0xc)
> 
>  (2) save faulting instruction address in sprg0 (lets say the value is 0xa.
> 		 			sprg0 will contain 0xa).

Small correction. sprg0 does not store the address of the faulting
instruction. It stores the isntruction itself. Regardless, the code
should work, I think.

RP
