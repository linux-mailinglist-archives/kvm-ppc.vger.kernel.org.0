Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946714A089
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Jun 2019 14:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfFRMPW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 08:15:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43223 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRMPW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Jun 2019 08:15:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Sn8l1xnkz9s3l;
        Tue, 18 Jun 2019 22:15:19 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH kernel] powerpc/pci/of: Parse unassigned resources
In-Reply-To: <20190614025916.123589-1-aik@ozlabs.ru>
References: <20190614025916.123589-1-aik@ozlabs.ru>
Date:   Tue, 18 Jun 2019 22:15:17 +1000
Message-ID: <87sgs7ozsa.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> The pseries platform uses the PCI_PROBE_DEVTREE method of PCI probing
> which is basically reading "assigned-addresses" of every PCI device.
> However if the property is missing or zero sized, then there is
> no fallback of any kind and the PCI resources remain undiscovered, i.e.
> pdev->resource[] array is empty.
>
> This adds a fallback which parses the "reg" property in pretty much same
> way except it marks resources as "unset" which later makes Linux assign
> those resources with proper addresses.

What happens under PowerVM is the big question.

ie. if we see such a device under PowerVM and then do our own assignment
what happens?

cheers
