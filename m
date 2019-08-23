Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516C29A729
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Aug 2019 07:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391664AbfHWFcu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Aug 2019 01:32:50 -0400
Received: from ozlabs.org ([203.11.71.1]:37185 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389826AbfHWFcu (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 23 Aug 2019 01:32:50 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46F95q6lYyz9s3Z; Fri, 23 Aug 2019 15:32:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566538367; bh=z02FCq36ZOlybuIQo9saHjlkCOE1r+GbTnZ2u8ZYozQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/JhSKyJna3dO+hzVwvKqr555OfMsYkSc6rEU4HDI6t7UXTZHTXFw0kUqNtRyy1fT
         XZyG/guq1JZXAD1JYZyREjzSKwT6GNg2EdxDMBXY+ve7kgOG8szGrIaMMU/8EKCnyd
         aqmdM2IfW0NRJlzhmm0iNJfc2uKXKdhv4xxiOzyxO5RBad4beOWcisAo4QRjQvL3uZ
         L08pjXagLF/YR+8V5WEbqt0bH/8AvagOKgWfNO33k8vwEm3ehMt6BldhXCpwlAKll+
         Swt7Wc9SWo0muhF2IbJRhtyIOpv1eFZ2DG4ba8glK3yeGGJCS6v7LuIh+B0hvTl8zy
         vgO9sc3zYRUcA==
Date:   Fri, 23 Aug 2019 14:17:47 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v7 0/7] KVMPPC driver to manage secure guest pages
Message-ID: <20190823041747.ctquda5uwvy2eiqz@oak.ozlabs.ibm.com>
References: <20190822102620.21897-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822102620.21897-1-bharata@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 22, 2019 at 03:56:13PM +0530, Bharata B Rao wrote:
> Hi,
> 
> A pseries guest can be run as a secure guest on Ultravisor-enabled
> POWER platforms. On such platforms, this driver will be used to manage
> the movement of guest pages between the normal memory managed by
> hypervisor(HV) and secure memory managed by Ultravisor(UV).
> 
> Private ZONE_DEVICE memory equal to the amount of secure memory
> available in the platform for running secure guests is created.
> Whenever a page belonging to the guest becomes secure, a page from
> this private device memory is used to represent and track that secure
> page on the HV side. The movement of pages between normal and secure
> memory is done via migrate_vma_pages(). The reverse movement is driven
> via pagemap_ops.migrate_to_ram().
> 
> The page-in or page-out requests from UV will come to HV as hcalls and
> HV will call back into UV via uvcalls to satisfy these page requests.
> 
> These patches are against hmm.git
> (https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=hmm)
> 
> plus
> 
> Claudio Carvalho's base ultravisor enablement patchset v6
> (https://lore.kernel.org/linuxppc-dev/20190822034838.27876-1-cclaudio@linux.ibm.com/T/#t)

How are you thinking these patches will go upstream?  Are you going to
send them via the hmm tree?

I assume you need Claudio's patchset as a prerequisite for your series
to compile, which means the hmm maintainers would need to pull in a
topic branch from Michael Ellerman's powerpc tree, or something like
that.

Paul.
