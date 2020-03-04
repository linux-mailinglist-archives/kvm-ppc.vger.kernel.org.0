Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF51793A9
	for <lists+kvm-ppc@lfdr.de>; Wed,  4 Mar 2020 16:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCDPhk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 4 Mar 2020 10:37:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726579AbgCDPhk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Mar 2020 10:37:40 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024Fanie076823
        for <kvm-ppc@vger.kernel.org>; Wed, 4 Mar 2020 10:37:38 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yhr4j3p2h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 04 Mar 2020 10:37:38 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Wed, 4 Mar 2020 15:37:37 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Mar 2020 15:37:34 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 024FbWbl49610874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Mar 2020 15:37:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BBA14C04A;
        Wed,  4 Mar 2020 15:37:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDBB04C050;
        Wed,  4 Mar 2020 15:37:29 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.197.107])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  4 Mar 2020 15:37:29 +0000 (GMT)
Date:   Wed, 4 Mar 2020 07:37:27 -0800
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
 <20200303185645.GB5416@oc0525413822.ibm.com>
 <20200304115948.7b2dfe10@bahia.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304115948.7b2dfe10@bahia.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20030415-0016-0000-0000-000002ED290B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030415-0017-0000-0000-000033507844
Message-Id: <20200304153727.GH5416@oc0525413822.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_05:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040114
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 04, 2020 at 11:59:48AM +0100, Greg Kurz wrote:
> On Tue, 3 Mar 2020 10:56:45 -0800
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > On Tue, Mar 03, 2020 at 06:45:20PM +0100, Greg Kurz wrote:
....snip.
> > > 
> > > This patch would allow at least to answer Cedric's question about
> > > kernel_irqchip=off, since this looks like the only thing needed
> > > to make it work.
> > 
> > hmm.. I am not sure. Are you saying
> > (a) patch the guest kernel to share the event queue page
> > (b) run the qemu with "kernel_irqchip=off"
> > (c) and the guest kernel with "svm=on"
> > 
> > and it should all work?
> > 
> 
> Yes.

Ok. 

(1) applied the patch which shares the EQ-page with the hypervisor.
(2) set "kernel_irqchip=off"
(3) set "ic-mode=xive"
(4) set "svm=on" on the kernel command line.
(5) no changes to the hypervisor and ultravisor.

And Boom it works!.   So you were right.


I am sending out the patch for (1) above ASAP.

Thanks,
RP

