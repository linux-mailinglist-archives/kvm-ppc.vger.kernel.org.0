Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11990228DF2
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 04:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgGVCXw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 22:23:52 -0400
Received: from kernel.crashing.org ([76.164.61.194]:41800 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgGVCXw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 22:23:52 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 06M2N9le018584
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 21 Jul 2020 21:23:17 -0500
Message-ID: <882f86756e78365c62f9ec2c57ef19744e0a3737.camel@kernel.crashing.org>
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting
 on MMIO access, in sprg0 register
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, bharata@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        sathnaga@linux.vnet.ibm.com, aik@ozlabs.ru
Date:   Wed, 22 Jul 2020 12:23:03 +1000
In-Reply-To: <875zags3qp.fsf@mpe.ellerman.id.au>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
         <875zags3qp.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2020-07-22 at 12:06 +1000, Michael Ellerman wrote:
> Ram Pai <linuxram@us.ibm.com> writes:
> > An instruction accessing a mmio address, generates a HDSI fault.  This fault is
> > appropriately handled by the Hypervisor.  However in the case of secureVMs, the
> > fault is delivered to the ultravisor.
> > 
> > Unfortunately the Ultravisor has no correct-way to fetch the faulting
> > instruction. The PEF architecture does not allow Ultravisor to enable MMU
> > translation. Walking the two level page table to read the instruction can race
> > with other vcpus modifying the SVM's process scoped page table.
> 
> You're trying to read the guest's kernel text IIUC, that mapping should
> be stable. Possibly permissions on it could change over time, but the
> virtual -> real mapping should not.

This will of course no longer work if userspace tries to access MMIO
but as long as you are ok limiting MMIO usage to the kernel, that's one
way.

iirc MMIO emulation in KVM on powerpc already has that race because of
HW TLB inval broadcast and it hasn't hurt anybody ... so far.

> > This problem can be correctly solved with some help from the kernel.
> > 
> > Capture the faulting instruction in SPRG0 register, before executing the
> > faulting instruction. This enables the ultravisor to easily procure the
> > faulting instruction and emulate it.
> 
> This is not something I'm going to merge. Sorry.

Another approach is to have the guest explicitly switch to using UV
calls for MMIO.

Cheers,
Ben.


