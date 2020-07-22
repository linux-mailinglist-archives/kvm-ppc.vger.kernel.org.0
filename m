Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD04E228DD8
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 04:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgGVCGL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 22:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731614AbgGVCGL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 22:06:11 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6335EC061794
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jul 2020 19:06:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBJjF53Wfz9sPB;
        Wed, 22 Jul 2020 12:06:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1595383569;
        bh=wqEt1+5/uXnORnuuS8zLv9jBm83d6ZbQUZER04RErfY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SSNY26poqYoLtT/r6QhXifDRj0sDPXzHqgJDJG3jSR0fO6CznoOfccDnD9VpYmSUR
         bBcd+IExksIk+zAa9VEljba4kNlu5O5NTF+fFc5oTXiIpHVQjjg3yrWhWvg1R6/5JH
         4EjFbiNvNXUyd0OtxeyZHRAiyMb6SP7vy9zVI28XR8ff6ouSsqeUoTbXsdE78YPn04
         VjHBHRsy+WXkvV+PEleDjSccf6lgukPjYbyX9Rlw6ppyTECe6ViHOSbmb1ZoMQ94vH
         VwRlMIytDaqsD5ZKpuRDDT/yZ+0XpSg2ob4EMy5gSrsS3ETfnSWmuybe3477C27SuJ
         iPDsKbn8bxk8A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, bharata@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        linuxram@us.ibm.com, sathnaga@linux.vnet.ibm.com, aik@ozlabs.ru
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO access, in sprg0 register
In-Reply-To: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
Date:   Wed, 22 Jul 2020 12:06:06 +1000
Message-ID: <875zags3qp.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Ram Pai <linuxram@us.ibm.com> writes:
> An instruction accessing a mmio address, generates a HDSI fault.  This fault is
> appropriately handled by the Hypervisor.  However in the case of secureVMs, the
> fault is delivered to the ultravisor.
>
> Unfortunately the Ultravisor has no correct-way to fetch the faulting
> instruction. The PEF architecture does not allow Ultravisor to enable MMU
> translation. Walking the two level page table to read the instruction can race
> with other vcpus modifying the SVM's process scoped page table.

You're trying to read the guest's kernel text IIUC, that mapping should
be stable. Possibly permissions on it could change over time, but the
virtual -> real mapping should not.

> This problem can be correctly solved with some help from the kernel.
>
> Capture the faulting instruction in SPRG0 register, before executing the
> faulting instruction. This enables the ultravisor to easily procure the
> faulting instruction and emulate it.

This is not something I'm going to merge. Sorry.

cheers
