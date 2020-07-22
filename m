Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A77229285
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 09:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgGVHuA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jul 2020 03:50:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53096 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgGVHt7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jul 2020 03:49:59 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M7VUIJ143166;
        Wed, 22 Jul 2020 03:49:40 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32e1x7rwn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 03:49:39 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06M7kIaX032222;
        Wed, 22 Jul 2020 07:49:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32brq82fgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:49:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06M7nZGD31326476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 07:49:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DC765204E;
        Wed, 22 Jul 2020 07:49:35 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.146.165])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 299A452052;
        Wed, 22 Jul 2020 07:49:31 +0000 (GMT)
Date:   Wed, 22 Jul 2020 00:49:29 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, bharata@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        sathnaga@linux.vnet.ibm.com, aik@ozlabs.ru
Message-ID: <20200722074929.GI7339@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
 <875zags3qp.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zags3qp.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO
 access, in sprg0 register
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220052
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 22, 2020 at 12:06:06PM +1000, Michael Ellerman wrote:
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

Actually the code does not capture the address of the instruction in the
sprg0 register. It captures the instruction itself. So should the mapping
matter?

> 
> > This problem can be correctly solved with some help from the kernel.
> >
> > Capture the faulting instruction in SPRG0 register, before executing the
> > faulting instruction. This enables the ultravisor to easily procure the
> > faulting instruction and emulate it.
> 
> This is not something I'm going to merge. Sorry.

Ok. Will consider other approaches.

RP
