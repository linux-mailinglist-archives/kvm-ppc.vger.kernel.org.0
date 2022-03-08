Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C04D1A79
	for <lists+kvm-ppc@lfdr.de>; Tue,  8 Mar 2022 15:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiCHO24 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Mar 2022 09:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiCHO2w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Mar 2022 09:28:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925F09FF7
        for <kvm-ppc@vger.kernel.org>; Tue,  8 Mar 2022 06:27:53 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228CKVWP023228;
        Tue, 8 Mar 2022 14:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SzuB/oix1bOrcb1DwVNc3/y8KKucPYC+QX9r/E+Lhh8=;
 b=Lk+f/x7v9Y9f/5isd9Gz4VJNGl9pCyOwIWh05ndtz4xJhx8v5CaXCXQbd3hEN27qFviI
 XkBnZbG9HWX2pDP8csP0/ZbF6/ca4SxjgPPO0ia/0z/7FVpf4VhdYqk6FqdqQgWL00zM
 fn8mRNBFEEc5zQRCyoB/tKca2Vw3DLtVohs9wOEmE/caMqYSG1oQLAEwi9vOxingo53Z
 8W+6H+ORyvzmyxFDJrzkXwhY8ht8q35pFaJ/tt/kXPC4OdE4kL/s2sFTwBztQgVgcjWC
 iPaMcJIYwQruNjkhLg7T8nkX1EqyTtAjPlhFhzrmzIpF+7prSQEqsv2V4IEZ+AkO0Kr2 FA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enx3m5d3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 14:27:40 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228ERMk4007404;
        Tue, 8 Mar 2022 14:27:39 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3ekyga2tvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 14:27:39 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228ERbtj33554708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 14:27:37 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52A13AC05E;
        Tue,  8 Mar 2022 14:27:37 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14974AC059;
        Tue,  8 Mar 2022 14:27:36 +0000 (GMT)
Received: from localhost (unknown [9.211.148.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Mar 2022 14:27:35 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, groug@kaod.org,
        david@gibson.dropbear.id.au
Subject: Re: [RFC PATCH 2/2] KVM: PPC: Book3S HV: Provide a more accurate
 MAX_VCPU_ID in P9
In-Reply-To: <f5ec9d55-bac3-b571-dfad-bd501cd364b3@csgroup.eu>
References: <20210412222656.3466987-1-farosas@linux.ibm.com>
 <20210412222656.3466987-3-farosas@linux.ibm.com>
 <f5ec9d55-bac3-b571-dfad-bd501cd364b3@csgroup.eu>
Date:   Tue, 08 Mar 2022 11:27:32 -0300
Message-ID: <87lexka59n.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -Wlq7r_-9K9BG57Bfg19phKaE1tQTlgR
X-Proofpoint-GUID: -Wlq7r_-9K9BG57Bfg19phKaE1tQTlgR
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxlogscore=970 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:

> Le 13/04/2021 =C3=A0 00:26, Fabiano Rosas a =C3=A9crit=C2=A0:
>> The KVM_CAP_MAX_VCPU_ID capability was added by commit 0b1b1dfd52a6
>> ("kvm: introduce KVM_MAX_VCPU_ID") to allow for vcpu ids larger than
>> KVM_MAX_VCPU in powerpc.
>>=20
>> For a P9 host we depend on the guest VSMT value to know what is the
>> maximum number of vcpu id we can support:
>>=20
>> kvmppc_core_vcpu_create_hv:
>>      (...)
>>      if (cpu_has_feature(CPU_FTR_ARCH_300)) {
>> -->         if (id >=3D (KVM_MAX_VCPUS * kvm->arch.emul_smt_mode)) {
>>                      pr_devel("KVM: VCPU ID too high\n");
>>                      core =3D KVM_MAX_VCORES;
>>              } else {
>>                      BUG_ON(kvm->arch.smt_mode !=3D 1);
>>                      core =3D kvmppc_pack_vcpu_id(kvm, id);
>>              }
>>      } else {
>>              core =3D id / kvm->arch.smt_mode;
>>      }
>>=20
>> which means that the value being returned by the capability today for
>> a given guest is potentially way larger than what we actually support:
>>=20
>> \#define KVM_MAX_VCPU_ID (MAX_SMT_THREADS * KVM_MAX_VCORES)
>>=20
>> If the capability is queried before userspace enables the
>> KVM_CAP_PPC_SMT ioctl there is not much we can do, but if the emulated
>> smt mode is already known we could provide a more accurate value.
>>=20
>> The only practical effect of this change today is to make the
>> kvm_create_max_vcpus test pass for powerpc. The QEMU spapr machine has
>> a lower max vcpu than what KVM allows so even KVM_MAX_VCPU is not
>> reached.
>>=20
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>
> This patch won't apply after commit a1c42ddedf35 ("kvm: rename=20
> KVM_MAX_VCPU_ID to KVM_MAX_VCPU_IDS")
>
> Feel free to resubmit if still applicable.

Thanks for the reminder, Christophe.

I was focusing on enabling the rest of the kvm-selftests:
https://lore.kernel.org/r/20220120170109.948681-1-farosas@linux.ibm.com

I'm preparing a v2 for that series and will try to include these patches
as well.

