Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A725C22986C
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 14:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGVMpP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jul 2020 08:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVMpP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jul 2020 08:45:15 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A45C0619DC
        for <kvm-ppc@vger.kernel.org>; Wed, 22 Jul 2020 05:45:14 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBZtZ29RMz9sSn;
        Wed, 22 Jul 2020 22:45:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1595421910;
        bh=zcL3E0CNVqX8VWWTtlfZYefsjM7u0ntmHNGu3ekg2DI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sJG5xf51yyztBoEsRAOMyQwqKrMVQW51dsVbpwfB0vMzXox69tbMlK2o6MbaNxhDh
         MX4rIbo4P//2bMEe4+uJZEemHASFYnrwogSs15g7nU88cY1vvCse7B+Lw3AuM8xNBU
         F29fzkpNFn7cbeyEnBBjUGSKuajUBC0fXOi164DsgyYrWqo44WTScXXA+UEmKeFb4S
         F8D3RHG60PI1pVQeYjWdF2hPwqgQpv/6WTyvqdXDIPoIpAD2cyagV16U+RS0aXjOvc
         In9NSaXSk5Hp906fLcxfac39J6D83JtfUYGlHOmY3WJmwe8fD8TZwQuvgSNQ83K8z4
         PxhWaMZ93/b7w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, bharata@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        sathnaga@linux.vnet.ibm.com, aik@ozlabs.ru
Subject: RE: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO access, in sprg0 register
In-Reply-To: <20200722074929.GI7339@oc0525413822.ibm.com>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com> <875zags3qp.fsf@mpe.ellerman.id.au> <20200722074929.GI7339@oc0525413822.ibm.com>
Date:   Wed, 22 Jul 2020 22:45:06 +1000
Message-ID: <87a6zrra5p.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Ram Pai <linuxram@us.ibm.com> writes:
> On Wed, Jul 22, 2020 at 12:06:06PM +1000, Michael Ellerman wrote:
>> Ram Pai <linuxram@us.ibm.com> writes:
>> > An instruction accessing a mmio address, generates a HDSI fault.  This fault is
>> > appropriately handled by the Hypervisor.  However in the case of secureVMs, the
>> > fault is delivered to the ultravisor.
>> >
>> > Unfortunately the Ultravisor has no correct-way to fetch the faulting
>> > instruction. The PEF architecture does not allow Ultravisor to enable MMU
>> > translation. Walking the two level page table to read the instruction can race
>> > with other vcpus modifying the SVM's process scoped page table.
>> 
>> You're trying to read the guest's kernel text IIUC, that mapping should
>> be stable. Possibly permissions on it could change over time, but the
>> virtual -> real mapping should not.
>
> Actually the code does not capture the address of the instruction in the
> sprg0 register. It captures the instruction itself. So should the mapping
> matter?

Sorry that was talking about reading the instruction by doing the page
walk, not with this patch applied.

cheers
